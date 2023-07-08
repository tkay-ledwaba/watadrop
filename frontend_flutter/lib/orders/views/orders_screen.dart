import 'package:flutter/material.dart';

import '../../common/style.dart';

class OrdersScreen extends StatefulWidget{
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: colorPrimary,
        foregroundColor: colorSecondary,
        title: Text("ORDERS"),

      ),
    );
  }
}