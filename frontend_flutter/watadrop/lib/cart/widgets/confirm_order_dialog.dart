import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../common/strings.dart';
import '../../common/style.dart';
import '../../database/remote_database.dart';
import '../../home/views/home_screen.dart';
import '../../widgets/toast_widget.dart';


CheckoutDialog(context, customer_id, store, delivery_address, amount, cart, plugin,_refreshData) {

  TextEditingController commentController = new TextEditingController();
  TextEditingController totalController = new TextEditingController();

  var subtotal;

  int item_qty = 1;


  totalController.text = amount.toString()+"0";

  String? cart_message="";
  String? comment="";

  for (int a = 0; a < count; a++){
    if (cart[a].name.toString().isNotEmpty){
      cart_message = "$cart_message\n${cart[a].qty.toString()} ${cart[a].name.toString()}";
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children:[
                          Text("Order Confirmation: ".toUpperCase(), textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize:14),
                          ),
                        ],
                      ),
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
                        Text("Store: ".toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12),),
                        Text('${store.name.toString()}',
                          style: TextStyle(fontSize: 10),
                        ),
                        SizedBox(height: 4),
                        Text("Delivery Address: ".toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12),),
                        Text('${delivery_address}',
                          style: TextStyle(fontSize: 10),
                        ),

                        Text('${cart_message}',
                          style: TextStyle(fontSize: 10),
                        ),

                        SizedBox(height: 8),
                        TextField(
                          controller: commentController,
                          onChanged: (value) {
                            comment = value.trim();
                          },
                          cursorColor: Colors.black,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: border_radius
                              ),
                              labelText: 'Comment',
                              isDense: true,
                              // Added this
                              contentPadding: EdgeInsets.all(8)),
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

                                  //Navigator.pop(context);

                                  var order_id = DateTime.now().millisecondsSinceEpoch.toString().substring(3,11);
                                  print(amount);

                                  Charge charge = Charge()
                                    ..amount = int.parse((amount.toString().replaceAll(".0", "")))*100
                                    ..reference = order_id
                                    ..currency = "ZAR"
                                  // or ..accessCode = _getAccessCodeFrmInitialization()
                                    ..email = current_email;
                                  CheckoutResponse response = await plugin.checkout(
                                    context ,
                                    method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
                                    charge: charge,
                                  );

                                  if (response.status){
                                    try{
                                      final response_data = await http
                                          .post(Uri.parse(orderUrl),
                                        body: {
                                          'customer': customer_id,
                                          'store': store.id.toString(),
                                          'price': amount,
                                          'address': delivery_address,
                                          'cart': cart_message,
                                          'date': DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
                                          'status': '1',
                                          'reference': order_id,
                                          'driver': '',
                                          'comment': ''

                                        },
                                      );

                                      print('error code:' + response_data.statusCode.toString());
                                      print(response_data.body);

                                      if (response_data.statusCode == 200){

                                        for (int a = 0; a < count; a++){
                                          Future<int> result = databaseHelper.deleteCart(cart[a].id);

                                          if (result != 0) {  // Success
                                            updateListView();
                                          }
                                        }

                                        showToastWidget("Order Placed Successfully", colorSuccess);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder:(context) => HomeScreen())
                                        );
                                        _refreshData();
                                      } else {
                                        Navigator.pop(context);
                                        showToastWidget(response_data.body.toString(), colorFailed);
                                      }

                                    } catch (e){
                                      Navigator.pop(context);
                                      showToastWidget(e.toString(), colorFailed);
                                    }

                                  }
                                  else {
                                    showToastWidget(response.message, colorFailed);
                                  }


                                },
                                child: Text('CHECKOUT'),
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