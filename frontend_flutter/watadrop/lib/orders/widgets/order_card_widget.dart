import 'package:flutter/material.dart';
import 'package:watadrop/common/strings.dart';
import 'package:watadrop/orders/views/order_detail_screen.dart';
import 'package:watadrop/orders/widgets/timeline.dart';
import 'package:watadrop/widgets/toast_widget.dart';

import '../../common/style.dart';

Widget OrderCardWidget(context, order){
  return InkWell(
    //padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
    child: Card(
        shape: RoundedRectangleBorder( //<-- SEE HERE
          side: BorderSide(
            color: Colors.black,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('#${order.reference.toString()}',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: colorSecondary
                      )
                  ),

                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('R${order.price.toString()}.00',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16.0,
                          //fontWeight: FontWeight.bold,
                        color: colorSecondary
                      )
                  ),
                  Text('${order.date.toString()}',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      )
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Timeline(order.status),
                  Text(checkStatus(order.status),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      )
                  )
                ],
              ),


            ],
          ),
        )
    ),
    onTap: (){
      if (order.status > 0){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrderDetailScreen(order: order,)
            )
        );
      } else {
        showToastWidget("Your order hasn't been accepted yet. Please be patient.", colorSecondary);
      }
    },
  );
}