import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:product_details_sqlite/helper/database_helper.dart';

class myProductList extends StatefulWidget {
  const myProductList({Key? key}) : super(key: key);

  @override
  _myProductListState createState() => _myProductListState();
}

class _myProductListState extends State<myProductList> {

  ScrollController _controller = new ScrollController();
  DatabaseHelper dbHelper = DatabaseHelper.instance;
  var productNamePass = TextEditingController();
  var pricePass = TextEditingController();
  var itemPass = TextEditingController();

  var showData = [];
  void show()  async{
    final fetchData  = await dbHelper.fetchProductData();
    setState(() {
      showData = fetchData;
    });
  }

  refresList(){
    setState(() {
      show();
    });
  }

  void _delete(int id) async{
    final result = await dbHelper.deleteData(id);
    print('deleted $result row(s): row $id');
    refresList();
  }

  @override
  void initState() {
    super.initState();
    refresList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Show Details"),
      ),
      body: SingleChildScrollView(
          child: Column(
            children: [
              Row(children: [
                Container(margin: EdgeInsets.only(left: 10,top: 10) ,child: Text("Product Name",style: TextStyle(fontSize: 18),),),
                Container(margin: EdgeInsets.only(left: 20,top: 10) ,child: Text("Price",style: TextStyle(fontSize: 18),),),
                Container(margin: EdgeInsets.only(left: 20,top: 10) ,child: Text("Item",style: TextStyle(fontSize: 18),),),
                Container(margin: EdgeInsets.only(left: 20,top: 10) ,child: Text("Edit",style: TextStyle(fontSize: 18),),),
                Container(margin: EdgeInsets.only(left: 20,top: 10) ,child: Text("Delete",style: TextStyle(fontSize: 18),),),
              ],),

              showData.isEmpty ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150.0,vertical: 300),
                child: Text("NO DATA", style: TextStyle( color: Colors.black,fontSize: 20,),),
              ) :
              ListView.builder(
                itemCount: showData.length,
                controller: _controller,
                shrinkWrap: true,
                scrollDirection : Axis.vertical,
                itemBuilder: (BuildContext context,index) {
                  return Container(
                    padding: EdgeInsets.only(bottom: 10,left: 10,right: 10),
                    child: Card(
                      color: Colors.white.withOpacity(1.0),
                      child : Row(
                        children: [
                          Container(width: 110 ,padding: EdgeInsets.all(20) ,child: Text('${showData[index]["productName"]}' ,style: TextStyle(color: Colors.black,fontSize: 15,),)),
                          Container(width: 50, margin: EdgeInsets.only(left: 20)  ,child: Center(child: Text('${showData[index]["productPrice"]}' ,style: TextStyle(color: Colors.black,fontSize: 15,),))),
                          Container(width: 20, margin: EdgeInsets.only(left: 20) ,child: Center(child: Text('${showData[index]["productItem"]}' ,style: TextStyle(color: Colors.black,fontSize: 15,),))),
                          Container(width: 20, margin: EdgeInsets.only(left: 30), child: Center(
                            child: IconButton(
                                onPressed: (){
                                  var proID = showData[index]["_id"];
                                  var proName = showData[index]["productName"];
                                  var proPrice = showData[index]["productPrice"];
                                  var proItem = showData[index]["productItem"];
                                  print("ID= $proID productName = $proName price = $proPrice Item= $proItem");
                                  updateform(proID,proName,proPrice,proItem);
                                },
                                icon : Icon(Icons.edit,color: Colors.black54,)),
                          ),
                          ),
                          Container(width: 20, margin: EdgeInsets.only(left: 40),
                            child: Center(
                              child: IconButton(
                                  onPressed: () {
                                    var proID = showData[index]["_id"];
                                    _delete(proID); },
                                  icon : Icon(Icons.delete,color: Colors.black54,)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          )
      ),
    );
  }

  // updateform(){
  updateform(id,productName,productPrice,productItm){
    print("id = $id");
    productNamePass.text=productName;
    print("price $productPrice");
    print("Item $productItm");
    pricePass.text = productPrice.toString();
    itemPass.text = productItm.toString();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Update Product Data"),
          actions: <Widget>[
            TextFormField(
              controller: productNamePass,
              keyboardType: TextInputType.text,
            ),
            TextFormField(
              controller: pricePass,
              maxLength: 5,
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: itemPass,
              maxLength: 1,
              keyboardType: TextInputType.number,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20,right: 20),
                  child: new RaisedButton(
                    child: new Text("OK"),
                    onPressed: () {
                      _update(id);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20,right: 20),
                  child: new RaisedButton(
                    child: new Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }

  void _update(id) async {
    int productId = id;
    Map<String, dynamic> row = {
      DatabaseHelper.columnId   : productId,
      DatabaseHelper.columnName : productNamePass.text,
      DatabaseHelper.columnPrice  : pricePass.text,
      DatabaseHelper.columnItem : itemPass.text,
    };
    //print(DatabaseHelper.columnName);
    print("dsd $productId");
    final rowsAffected = await dbHelper.update(row);
    print('updated $rowsAffected row(s)');
    refresList();
  }

}
