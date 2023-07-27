import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:sqflite/sqflite.dart';
import 'package:watadrop/cart/models/cart.dart';
import 'package:watadrop/cart/widgets/card_widget.dart';
import 'package:watadrop/cart/widgets/confirm_order_dialog.dart';

import 'package:watadrop/common/style.dart';

import '../../common/strings.dart';
import '../../config/location_permissions.dart';
import '../../home/models/store.dart';
import '../../home/views/home_screen.dart';
import '../../widgets/toast_widget.dart';

final cartScaffoldKey = GlobalKey<ScaffoldState>();

class CartScreen extends StatefulWidget {

  final Store selected_store;
  final String delivery_address;
  final String distance;

  const CartScreen({super.key, required this.selected_store, required this.delivery_address, required this.distance});

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

      calculate_delivery_price(widget.distance, widget.delivery_address);

      if (count > 0){
        for (int x = 0; x < count; x++){
          total_price = total_price + double.parse(myData[x].price);
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

   calculate_delivery_price(distance, delivery_address) async {

    if (distance != null){
      if (double.parse(distance) < 1){
        setState(() {
          delivery_price = 20.00;
        });
      } else {
        setState(() {
          delivery_price = delivery_price + (double.parse(distance) * 6).round();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //calculate_delivery_price(widget.distance, widget.delivery_address);
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
                                Text('R ${(total_price+delivery_price).toStringAsFixed(2)}'),

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

                      CheckoutDialog(
                          context, current_user!.id.toString(),
                          widget.selected_store,
                          widget.delivery_address,
                          (total_price+delivery_price).toString(),
                          myData,
                          plugin,
                          _refreshData
                      );

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


}





