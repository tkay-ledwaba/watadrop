
import 'package:flutter/material.dart';
import 'package:watadrop/cart/models/cart.dart';
import 'package:watadrop/common/style.dart';

import '../../common/strings.dart';
import '../../home/views/home_screen.dart';
import '../../widgets/toast_widget.dart';
import '../views/cart_screen.dart';


showCardWidget(myData, context, index, databaseHelper, updateListView()){

  TextEditingController qtyController = new TextEditingController();
  TextEditingController totalController = new TextEditingController();

  var num_of_case = 1;
  var subtotal;

  num_of_case = myData[index].qty;
  qtyController.text = myData[index].qty.toString();
  totalController.text = (double.parse(myData[index].price.toString()).toStringAsFixed(2));

  return Card(
      shape: RoundedRectangleBorder( //<-- SEE HERE
        side: BorderSide(
          color: Colors.black,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      child: Expanded(
        child: Row(
          //mainAxisSize: MainAxisSize.max,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(4),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: colorPrimary,
                backgroundImage: NetworkImage(myData[index].image),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    myData[index].name.toString(),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          //height: 32,
                          width: 72,
                          child: TextField(
                              readOnly: true,
                              controller: totalController,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  prefix: Text("R",
                                    style: TextStyle(
                                        color: colorSecondary,
                                        fontWeight: FontWeight.w300
                                    )
                                  )
                              ),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300
                              )
                          )

                      ),
                      SizedBox(
                        height: 28,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(onTap: (){

                              if (num_of_case != 1) {
                                num_of_case--;
                                qtyController.text = num_of_case.toString();
                                subtotal = double.parse(myData[index].price)/myData[index].qty*num_of_case;

                                totalController.text = subtotal.toString()+'0';
                                Cart cart = Cart(
                                  myData[index].id,
                                  myData[index].name,
                                  myData[index].image,
                                  subtotal.toString(),
                                  num_of_case,
                                );
                                Future<int> result = databaseHelper.updateCart(cart);

                                if (result != 0) {  // Success
                                  showToastWidget('${myData[index].name} updated from cart', colorSuccess);
                                  updateListView();

                                } else {  // Failure
                                  showToastWidget('Failed to update cart', colorFailed);
                                }
                              }

                            }, child: const Icon(Icons.indeterminate_check_box_sharp, color: Colors.lightBlue)),
                            SizedBox(
                              width: 8,
                              child: Center(
                                  child: TextField(
                                    readOnly: true,
                                    controller: qtyController,
                                    decoration: InputDecoration(border: InputBorder.none,
                                        isDense: true
                                    ),
                                    style: TextStyle(
                                      fontSize: 10,

                                    ),
                                  )
                              ),
                            ),
                            GestureDetector(onTap: (){
                              if (num_of_case != 5){
                                num_of_case++;
                                qtyController.text = num_of_case.toString();
                                subtotal = double.parse(myData[index].price)/myData[index].qty*num_of_case;
                                totalController.text = subtotal.toString()+'0';
                                Cart cart = Cart(
                                  myData[index].id,
                                  myData[index].name,
                                  myData[index].image,
                                  subtotal.toString(),
                                  num_of_case,
                                );

                                Future<int> result = databaseHelper.updateCart(cart);

                                if (result != 0) { // Success
                                  showToastWidget('${myData[index]
                                      .name} updated from cart', colorSuccess);
                                  updateListView();


                                }


                              }
                            }, child: const Icon(Icons.add_box_sharp, color: Colors.lightBlue)),
                            SizedBox(
                              width: 16,
                            ),
                            GestureDetector(onTap: (){
                              Future<int> result = databaseHelper.deleteCart(myData[index].id);

                              if (result != 0) {  // Success
                                showToastWidget('${myData[index].name} deleted from cart', colorSuccess);
                                updateListView();
                                count--;



                              } else {  // Failure
                                showToastWidget( 'Failed to delete from cart', colorFailed);
                              }
                            }, child: Icon(Icons.delete))

                          ],
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            )



          ],
        )
      )
  );

}