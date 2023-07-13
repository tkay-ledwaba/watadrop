import 'package:flutter/material.dart';

import '../../cart/models/cart.dart';
import '../../common/style.dart';
import '../../widgets/toast_widget.dart';
import '../views/home_screen.dart';

ProductDetailsDialog(context, product,_refreshData) {

  TextEditingController qtyController = new TextEditingController();
  TextEditingController totalController = new TextEditingController();

  var subtotal;

  int item_qty = 1;

  qtyController.text = item_qty.toString();
  totalController.text = product.price.toString()+".00";

  String display_name = "${product.name} (${product.volume}ml)";

  if (product.qty>1){
    display_name = "${product.name} (${product.volume}ml x ${product.qty})";

  }
  if (product.volume >999){
    display_name = "${product.name} (${product.volume/1000}L x ${product.qty})";
  }

  showDialog(
      context: context,
      builder: (context){

        return ScaffoldMessenger(
            child: Builder(builder: (context) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: AlertDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0)
                      )
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children:[
                          Text(product.name, textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize:18),
                          ),
                        ],
                      ),
                      GestureDetector(
                        child: const Icon(Icons.close),
                        onTap: (){
                          Navigator.pop(context);

                        },
                      )
                    ],
                  ),
                  content: SingleChildScrollView(

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Hero(
                            tag: product.id,
                            child: CircleAvatar(
                              backgroundColor: colorPrimary,
                              backgroundImage: NetworkImage(
                                product.image,
                              ),
                              radius: MediaQuery.of(context).size.width / 4,
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[

                            Text("Price".toUpperCase()),
                            Padding(
                                padding: EdgeInsets.only(right: 16),
                                child: Text(
                                  "R${product.price}.00",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: colorSecondary
                                  ),
                                ))
                          ],
                        ),
                        Row(
                          //crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Quantity".toUpperCase()),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(onPressed: (){

                                  if (item_qty != 1) {
                                    item_qty--;
                                    qtyController.text = item_qty.toString();
                                    subtotal = product.price*item_qty;

                                    totalController.text = subtotal.toString()+'.00';

                                  }

                                }, icon: const Icon(Icons.indeterminate_check_box_sharp, color: Colors.lightBlue)),

                                SizedBox(
                                  width: 12,
                                  child: TextField(
                                    readOnly: true,
                                    controller: qtyController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),

                                IconButton(onPressed: (){
                                  if (item_qty != 5){
                                    item_qty++;
                                    qtyController.text = item_qty.toString();
                                    subtotal = product.price*item_qty;
                                    totalController.text = subtotal.toString()+'.00';

                                  }
                                }, icon: const Icon(Icons.add_box_sharp, color: Colors.lightBlue)),


                              ],
                            ),
                          ],
                        ),
                        Visibility(
                            visible: product.discount==0?false:true,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Discount"),
                                Text(
                                  "- R${product.discount}.00",
                                  style: TextStyle(
                                      color: colorSecondary
                                  ),
                                ),
                              ],
                            )
                        ),
                        Text(
                          "Description".toUpperCase()+"\n${product.description!.replaceAll("*", "\n")}",
                        ),

                        SizedBox(
                          height: 48,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 50,
                                child: TextField(
                                  readOnly: true,
                                  controller: totalController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: colorAccent,
                                  onPrimary: Colors.white,
                                  //shadowColor: Colors.greenAccent,
                                  //elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: border_radius),
                                  minimumSize: Size(24, 32), //////// HERE
                                ),
                                onPressed: () async {
                                  Future<int> result = databaseHelper.insertCart(Cart(
                                      product.id,
                                      display_name,
                                      product.image.toString(),
                                      product.price.toString(),
                                      item_qty
                                  )
                                  );

                                  updateListView();

                                  if (result != 0) {  // Success
                                    showToastWidget('${display_name} - Added to cart', colorSuccess);

                                    Navigator.pop(context, result);
                                    _refreshData();

                                  } else {  // Failure
                                    showToastWidget('Failed to add to cart', colorFailed);
                                  }
                                },
                                child: Text('Add To Cart'),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              );
            },)
        );
      }
  );


}