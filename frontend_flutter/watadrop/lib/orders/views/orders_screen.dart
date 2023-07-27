import 'package:flutter/material.dart';
import 'package:watadrop/common/strings.dart';
import 'package:watadrop/orders/widgets/order_card_widget.dart';
import 'package:watadrop/widgets/progress_widget.dart';

import '../../common/style.dart';
import '../../database/remote_database.dart';

class OrdersScreen extends StatefulWidget{
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrders().then((value) => print(value));
  }

  @override
  Widget build(BuildContext context){

    print('orders');

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: colorPrimary,
        foregroundColor: colorSecondary,
        title: Text("ORDERS"),
      ),
      body: FutureBuilder(
        future: getOrders(),
        builder: (ctx, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting){
            return showProgressWidget(context);
          } else if (snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasData){
              final orders = snapshot.data!;
              print('Orders'+orders.toString());
              return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Column(
                    children: orders.map((order){
                      return OrderCardWidget(context, order);
                    }).toList(),
                  )
              );
            }
            else if (!snapshot.hasData){
              return Center(
                child: Text("You have no orders"),
              );
            }
          }

          return showProgressWidget(context);
        },
      ),
    );
  }
}