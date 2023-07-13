import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:sqflite/sqflite.dart';
import 'package:watadrop/cart/models/cart.dart';
import 'package:watadrop/cart/widgets/card_widget.dart';

import 'package:watadrop/common/style.dart';
import 'package:http/http.dart' as http;
import '../../common/strings.dart';
import '../../config/location_permissions.dart';
import '../../home/models/store.dart';
import '../../home/views/home_screen.dart';
import '../../widgets/toast_widget.dart';

final cartScaffoldKey = GlobalKey<ScaffoldState>();

class CartScreen extends StatefulWidget {

  final Store store_address;
  final String delivery_address;

  const CartScreen({super.key, required this.store_address, required this.delivery_address});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {


  List<Cart> myData = <Cart>[];
  double total_price = 0.00;
  double delivery_price = 20.00;

  bool _isLoading = true;

  final _controller = TextEditingController();

  final plugin = PaystackPlugin();

  // This function is used to fetch all data from the database
  void _refreshData() async {
    final data = await databaseHelper.getCartList();
    setState(() {
      myData = data;
      _isLoading = false;
      count = myData.length;
      if (count > 0){
        for (int x = 0; x < count; x++){
          total_price = total_price + double.parse(myData[x].price) + delivery_price;
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshData();

    plugin.initialize(
        publicKey: paystack_public_key);
  }

  @override
  void dispose() {
    _controller.dispose();
    //_getCurrentPosition();
    super.dispose();
  }

   calculate_delivery_price(store_address, delivery_address) async {
    Future<String> distanceFuture =  getDistance(store_address!, delivery_address!);
    var distance = await distanceFuture;

    if (distance != null){
      if (double.parse(distance) < 1){
        setState(() {
          delivery_price = 20.00;
        });
      } else {
        setState(() {
          delivery_price = delivery_price + (double.parse(distance) * 6);
        });
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimary,
      appBar: AppBar(
          backgroundColor: colorPrimary,
          foregroundColor: colorSecondary,

          //centerTitle: true,
          title: Text("CART"),
          elevation: 0,

          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 16.0, top: 4),
                child: GestureDetector(
                  child: Icon(Icons.delete_forever, color: colorSecondary,),
                  onTap: () {
                    for (int a = 0; a < count; a++){
                      Future<int> result = databaseHelper.deleteCart(myData[a].id);

                      if (result != 0) {  // Success
                        updateListView();
                      }
                    }
                    count = cartList.length;
                    showToastWidget('Cart has been cleared.', colorSuccess);
                    updateListView();
                    Navigator.pop(context);

                  },
                )
            )
          ]
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : myData.isEmpty
          ? const Center(child: Text("Your cart is empty. Please add something.", style: TextStyle(color: Colors.white, fontSize: 16),))
          : ListView.builder(
          itemCount: myData.length,
          itemBuilder: (context, index) =>
              SingleChildScrollView(
                child: showCardWidget(myData, context, index, databaseHelper, updateListView),
              )
      ),
      bottomSheet: BottomSheet(

        builder: (context){
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder( //<-- SEE HERE
                  side: BorderSide(
                    color: Colors.black,
                  ),
                ),
                child:  Padding(padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //Icon(Icons.location_pin, color: colorSecondary,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Subtotal:'),
                                Text('Delivery Fee:'),
                                Text('Total:'),

                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('R ${total_price.toStringAsFixed(2)}'),
                                Text('R ${delivery_price.toStringAsFixed(2)}'),
                                Text('R ${total_price+delivery_price}0'),

                              ],
                            )

                          ],
                        )
                      ],
                    )
                ),
              ),
              ElevatedButton(
                  onPressed: () async {

                    if (widget.delivery_address
                        .isNotEmpty){
                      String? cart_message="";
                      var order_id = DateTime.now().millisecondsSinceEpoch.toString();

                      var amount = int.parse((total_price+delivery_price).toStringAsFixed(0))*100;
                      print(amount);

                      Charge charge = Charge()
                        ..amount = int.parse((total_price+delivery_price).toStringAsFixed(0))*100
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
                        for (int a = 0; a < count; a++){
                          if (myData[a].name.toString().isNotEmpty){
                            cart_message = "$cart_message\n${myData[a].qty.toString()} ${myData[a].name.toString()}";
                          }
                        }

                        placeOrder(context,
                          current_user!.id,
                          widget.store_address.id,
                          amount,
                          widget.delivery_address,
                          cart_message!,
                        );


                        for (int a = 0; a < count; a++){
                          Future<int> result = databaseHelper.deleteCart(myData[a].id);

                          if (result != 0) {  // Success
                            updateListView();
                          }
                        }

                        showToastWidget("Order Placed Successfully", colorSuccess);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder:(context) => HomeScreen())
                        );
                      } else {
                        showToastWidget(response.message, colorFailed);
                      }

                    } else{
                      showToastWidget("Please set address.", colorFailed);
                    }

                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50), // NEW
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),backgroundColor: colorSuccess
                  ),
                  child: Text('CHECKOUT', style: TextStyle(color: Colors.white),)
              ),
            ],
          );
        }, onClosing: () {
        Navigator.pop(context);
      },
      ),
    );
  }

  void gotoHomeScreen() {
    Navigator.pop(context);
  }
  void updateListView() {

    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {

      Future<List<Cart>> noteListFuture = databaseHelper.getCartList();
      noteListFuture.then((noteList) {
        this.myData = noteList;
        //count = noteList.length;
      });
    });
  }

  void placeOrder(
      BuildContext context,
      int customer_id,
      int store_id,
      int price,
      String address,
      String cart,
      ) async {

    try{
      final response_data = await http
          .post(Uri.parse(orderUrl),
        body: {
          'customer': customer_id,
          'store': store_id,
          'price': price,
          'address': address,
          'cart': cart,
        },
      );

      print(response_data.statusCode);

      if (response_data.statusCode == 200){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (context) => HomeScreen()), (Route route) => false);
      } else {
        Navigator.pop(context);
        showToastWidget(response_data.body.toString(), colorFailed);
      }

    } catch (e){
      Navigator.pop(context);
      showToastWidget(e.toString(), colorFailed);
    }

  }

}





