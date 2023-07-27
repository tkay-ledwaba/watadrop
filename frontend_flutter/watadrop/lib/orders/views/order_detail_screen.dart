import 'package:flutter/material.dart';
import 'package:watadrop/common/style.dart';

import '../../common/strings.dart';
import '../widgets/timeline.dart';
import '../models/order.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  OrderDetailScreenState createState() => OrderDetailScreenState();

}

class OrderDetailScreenState extends State<OrderDetailScreen> {

  var status;
  var address;
  var datetime;
  var amount;
  var agent;
  var agent_id;
  var cart;

  late String message;
  late TextEditingController text_controller;

  @override
  void initState(){
    super.initState();
    text_controller = TextEditingController();
  }

  @override
  void dispose() {
    text_controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: colorAccent,
      // Appbar
      appBar: AppBar(
        // Title
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorSecondary,), onPressed: (){
          Navigator.pop(context);
        },
        ),
        backgroundColor: colorPrimary,
        title: Text('Order #${widget.order.reference}', style: TextStyle(color: colorPrimary),),
        actions: [
          IconButton(onPressed: (){

          }, icon: Icon(Icons.cancel_outlined))
        ],
      ),
      // Body
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                      shape: RoundedRectangleBorder( //<-- SEE HERE
                        side: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Address:'),
                                    Text('Date:'),
                                    Text('Paid:'),
                                    Text('Driver:'),
                                    Text('Cart:')
                                  ],
                                ),
                                Column(
                                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text('$address'),
                                    Text('$datetime'),
                                    Text('$amount'),
                                    Text('${agent}'),
                                    Text('${cart.toString().replaceAll(", ", "\n")}')
                                  ],
                                )
                              ],
                            ),
                            Timeline(status),
                            Text(checkStatus(status)),

                          ],
                        ),
                      )
                  )
                ],
              )
          )
        ],
      )
    );
  }
}