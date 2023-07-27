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
      //backgroundColor: colorAccent,
      // Appbar
      appBar: AppBar(
        elevation: 0.5,
        foregroundColor: colorSecondary,
        // Title
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorSecondary,), onPressed: (){
          Navigator.pop(context);
        },
        ),
        backgroundColor: colorPrimary,
        title: Text('ORDER #${widget.order.reference}'),
      ),
      // Body
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
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
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('ADDRESS:', style: TextStyle(fontWeight: FontWeight.bold),),
                            Text('${widget.order.address}'),

                            Divider(
                              height: 1,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('DATE:',style: TextStyle(fontWeight: FontWeight.bold),),
                                Text('${widget.order.date}'),
                              ],
                            ),

                            Divider(
                              height: 1,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('PAID:',style: TextStyle(fontWeight: FontWeight.bold),),
                                Text('R${widget.order.price}.00'),
                              ],
                            ),

                            Divider(
                              height: 1,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('DRIVER:' ,style: TextStyle(fontWeight: FontWeight.bold)),
                                Text('Tevin P'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Timeline(widget.order.status),
                                Text(checkStatus(widget.order.status),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black,
                                    )
                                )
                              ],
                            ),

                            Divider(
                              height: 1,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text('BOUGHT:',style: TextStyle(fontWeight: FontWeight.bold),),
                            Text('${widget.order.cart}'),

                            Visibility(
                                visible: (widget.order.comment.isNotEmpty)?true:false,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Divider(
                                      height: 1,
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text('NB:',style: TextStyle(fontWeight: FontWeight.bold),),
                                    Text('${widget.order.comment}')
                                  ],
                                )
                            )
                          ],
                        ),
                      )
                  ),

                  SizedBox(
                    height: 16,
                  ),

                  Card(
                      shape: RoundedRectangleBorder( //<-- SEE HERE
                        side: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('NOTEPAD:', style: TextStyle(fontWeight: FontWeight.bold),),
                            ElevatedButton(onPressed: (){}, child: Text("Add Note", style: TextStyle(color: colorPrimary),))
                          ],
                        ),
                      )
                  ),
                ],
              )
          )
        ],
      )
    );
  }
}