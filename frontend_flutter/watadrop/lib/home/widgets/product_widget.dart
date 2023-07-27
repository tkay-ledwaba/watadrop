import 'package:flutter/material.dart';
import 'package:watadrop/home/widgets/product_details_dialog.dart';

import '../../common/style.dart';


Widget ProductWidget(context, product, _refreshData){

  String display_name = "${product.name}\n(${product.volume}ml x ${product.qty})";

  if (product.volume >999){

    if (product.qty == 1){
      display_name = "${product.name} (${(product.volume/1000).toString().replaceAll(".0", "")}L)";
    } else {
      display_name = "${product.name}\n(${(product.volume/1000).toString().replaceAll(".0", "")}L x ${product.qty})";
    }
  }

  return Card(
      shape: RoundedRectangleBorder( //<-- SEE HERE
        side: BorderSide(
          color: Colors.black,
        ),
      ),
      child: GestureDetector(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SizedBox(
                  height: 88,
                  width: double.infinity,
                  child: Image.network(product.image),
                )
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text('$display_name',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                      color: Colors.black,
                    )
                )
            ),

            SizedBox(
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text('R${product.price}.00',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                          color: Colors.black,
                        )
                    ),),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: colorAccent,
                      onPrimary: Colors.white,
                      //shadowColor: Colors.greenAccent,
                      //elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: border_radius),
                      minimumSize: Size(20, 25), //////// HERE
                    ),
                    onPressed: () async {
                      ProductDetailsDialog(context, product,_refreshData);
                    },
                    child: Text('ADD'),
                  )
                ],
              ),
            ),
          ],
        ),
        onTap: (){

          ProductDetailsDialog(context, product,_refreshData);
        },
      )
  );
}