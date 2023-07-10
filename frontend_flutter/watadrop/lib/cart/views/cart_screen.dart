import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/style.dart';


class CartScreen extends StatefulWidget{
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>{

  TextEditingController addressController = TextEditingController();
  String? address;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      //backgroundColor: colorPrimary,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: colorPrimary,
        foregroundColor: colorSecondary,
        title: SizedBox(
          height: 42,
          //width: 250,
          child:Center(
            child: TextField(
              readOnly: true,
              controller: addressController,
              onChanged: (value) {
                address = value.trim();
              },
              cursorColor: colorAccent,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: border_radius
                  ),
                  hintText: "Please set address",
                  labelText: 'Delivery Address',
                  isDense: true,
                  // Added this
                  contentPadding: EdgeInsets.all(8)),
              onTap: (){
                
              },
            ),
          )
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16, left: 16),
            child: Icon(Icons.delete_forever_outlined),
          ),
        ],
      ),
    );
  }
}