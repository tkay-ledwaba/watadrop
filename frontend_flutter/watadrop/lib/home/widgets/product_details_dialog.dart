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

  String display_name = "${product.name}\n(${product.volume}ml x ${product.qty})";

  if (product.volume >999){

    if (product.qty == 1){
      display_name = "${product.name} (${(product.volume/1000).toString().replaceAll(".0", "")}L)";
    } else {
      display_name = "${product.name}\n(${(product.volume/1000).toString().replaceAll(".0", "")}L x ${product.qty})";
    }
  }
  showDialog(
      context: context,
      builder: (context){

        return ScaffoldMessenger(
            child: Builder(builder: (context) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: border_radius
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
                        Text(display_name.toString().toUpperCase(), textAlign: TextAlign.left,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize:14),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[

                            Text("Price".toUpperCase()),
                            Text(
                              "R${product.price}.00",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: colorSecondary
                              ),
                            )
                          ],
                        ),
                        Row(
                          //crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Quantity".toUpperCase()),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
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
                            )
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
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 70,
                                child: TextField(
                                  readOnly: true,
                                  controller: totalController,
                                  decoration: InputDecoration(
                                    prefix: Text("R",
                                      style: TextStyle(
                                        color: colorSecondary,
                                          fontWeight: FontWeight.bold, fontSize:18),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize:18),
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
                                      display_name.replaceAll("\n", " "),
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