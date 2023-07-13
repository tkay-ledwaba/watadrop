
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
  totalController.text = myData[index].price.toString()+"0";

  return Card(
      shape: RoundedRectangleBorder( //<-- SEE HERE
        side: BorderSide(
          color: Colors.black,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.all(4),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: colorPrimary,
              backgroundImage: NetworkImage(myData[index].image),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: 16,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(0, 0, 0,0),
                      child: Text(
                        myData[index].name.toString(),
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700

                        ),
                      ),
                    ),

                    Padding(padding: EdgeInsets.fromLTRB(12, 18, 4,0),
                      child: SizedBox(
                        width: 48,
                        child: TextField(
                          readOnly: true,
                          controller: totalController,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(border: InputBorder.none),
                            style: TextStyle(fontSize: 14)
                        ),

                      ),
                    )


                  ],
                ),
              ),
              SizedBox(
                height: 32,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(onPressed: (){

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

                        }, icon: const Icon(Icons.indeterminate_check_box_sharp, color: Colors.lightBlue)),

                        SizedBox(
                          width: 12,
                          child: TextField(
                            readOnly: true,
                            controller: qtyController,
                            decoration: InputDecoration(border: InputBorder.none),
                          ),
                        ),

                        IconButton(onPressed: (){
                          if (num_of_case != 5){
                            num_of_case++;
                            qtyController.text = num_of_case.toString();
                            subtotal = double.parse(myData[index].price)/myData[index].qty*num_of_case;
                            totalController.text = subtotal.toString();

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
                        }, icon: const Icon(Icons.add_box_sharp, color: Colors.lightBlue)),


                      ],
                    ),
                    IconButton(onPressed: (){
                      Future<int> result = databaseHelper.deleteCart(myData[index].id);

                      if (result != 0) {  // Success
                        showToastWidget('${myData[index].name} deleted from cart', colorSuccess);
                        updateListView();
                        count--;



                      } else {  // Failure
                        showToastWidget( 'Failed to delete from cart', colorFailed);
                      }
                    }, icon: Icon(Icons.delete))
                  ],
                ),
              ),

            ],
          )
        ],
      )
  );

}