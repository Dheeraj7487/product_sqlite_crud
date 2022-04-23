import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:product_details_sqlite/helper/database_helper.dart';
import 'package:product_details_sqlite/productItem/show.dart';
import 'package:sqflite/sqflite.dart';

class myProductApp extends StatelessWidget {
  const myProductApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Product Page",
      home: new myProduct(),
    );
  }
}

class myProduct extends StatefulWidget {
  const myProduct({Key? key}) : super(key: key);

  @override
  _myProductState createState() => _myProductState();
}

class _myProductState extends State<myProduct> {

  var productNamePass = TextEditingController();
  var pricePass = TextEditingController();
  var itemPass = TextEditingController();

  DatabaseHelper dbHelper = DatabaseHelper.instance;

  final _formKey = GlobalKey<FormState>();

  _insert() async {
    Database? db = await DatabaseHelper.instance.database;
    Map<String, dynamic> row = {
      DatabaseHelper.columnName : productNamePass.text.toString(),
      DatabaseHelper.columnPrice  : pricePass.text.toString(),
      DatabaseHelper.columnItem : itemPass.text.toString(),
    };
    int? id = await db?.insert(DatabaseHelper.table, row);
    print(await db?.query(DatabaseHelper.table));

    productNamePass.clear();
    pricePass.clear();
    itemPass.clear();

  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Product Page"),
      ),

      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(left: 20, right: 20,bottom: 70 , top: 100),
                  child : new Center(child: new Text("Add Product Details",textAlign: TextAlign.center, style: new TextStyle(fontSize: 40,),),)
              ),

              Container(
                margin: EdgeInsets.only(left: 20, right: 20,top: 30),
                child: TextFormField(
                  controller: productNamePass,
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "This field is required";
                    }return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter Product Name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),


              Container(
                margin: EdgeInsets.only(left: 20, right: 20,top: 30),
                child: TextFormField(
                  controller: pricePass,
                  keyboardType: TextInputType.number,

                  maxLength: 5,
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "This is required";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(left: 20, right: 20,top: 30),
                child: TextFormField(
                  controller: itemPass,
                  maxLength: 1,
                  keyboardType: TextInputType.number,
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "This is required";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter Item',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 20, top: 40),
                    child: ElevatedButton(

                      onPressed: () async {
                        if(_formKey.currentState!.validate()){
                          _insert();
                        }
                      } ,
                      style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),),

                      child: new Text("Add"),),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 40),
                    child: ElevatedButton(

                      onPressed: () async {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => myProductList()));
                      } ,
                      style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),),
                      child: new Text("Show"),),
                  ),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

