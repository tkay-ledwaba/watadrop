
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watadrop/home/models/product.dart';
import 'package:watadrop/widgets/toast_widget.dart';

import '../../account/views/account_screen.dart';
import '../../cart/views/cart_screen.dart';
import '../../common/strings.dart';
import '../../common/style.dart';
import '../../config/location_services.dart';
import '../../orders/views/orders_screen.dart';
import '../../user/models/user.dart';

import '../../user/views/landing_screen.dart';
import '../../widgets/progress_widget.dart';
import '../models/store.dart';
import '../widgets/address_widget.dart';
import '../widgets/product_widget.dart';

final scaffoldKey = GlobalKey<ScaffoldState>();

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Initialize loading if true show progress indicator
  bool isLoading = true;

  String? selected_store;

  List<Store> stores = [];
  Client client = http.Client();

  List<String> dishCategories = [
    'Products',
    'Refill',
    //'Subscriptions',
    //'Services'
  ];

  int _active = 0;

  TextEditingController storeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String? store;
  String? address;



  Future<User?> getUser() async {

    User? current_user;

    getCurrentAddress().then((value) => addressController.text = value);

    final response = await http
        .get(Uri.parse(getuserUrl)

    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      var responseData = json.decode(response.body);
      for (var singleCollection in responseData){
        print(singleCollection['first_name']);
        User user = User(
          id: singleCollection['id'],
          first_name: singleCollection['first_name'],
          last_name: singleCollection['last_name'],
          email: singleCollection['email'],
        );

        if (user.email == current_email){
          setState(() {
            current_user = user;
            isLoading = false;
          });
        }

      }

      return current_user;

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(showToastWidget("Failed to load user", colorFailed));
    }
  }

  Future<List<Store>> getStores() async {

    final response = await http
        .get(Uri.parse(storesUrl)
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      var responseData = json.decode(response.body);

      for (var singleCollection in responseData){
        Store collection = Store(
            id: singleCollection['id'],
            name: singleCollection['name'],
            address: singleCollection['address'],
            phone: singleCollection['phone'],
            email: singleCollection['email']
        );

        stores.add(collection);
      }

      if (mounted){
        if (stores.isNotEmpty){

          setState(() {
            storeController.text = selected_store = stores[0].name;

          });
        }
      }

      return stores;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load store');
    }
  }

  Future<List<Product>> getProducts(id) async {

    List<Product> products = [];

    final response = await http
        .get(Uri.parse(productsUrl),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      var responseData = json.decode(response.body);

      for (var item in responseData){
        Product product = Product(
            id: item['id'],
            menu_id: item['menu_id'],
            category_id: item['category_id'],
            name: item['name'],
            description: item['description'],
            image: item['image'],
            qty: item['qty'],
            volume: item['volume'],
            price: item['price'],
            discount: item['discount'],
        );

        if (id+1 == product.menu_id){
          print(product.menu_id);

          products.add(product);
        }
      }

      return products;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUser();
    // Get details of available stores
    getStores();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    storeController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    getProducts(_active);

    return FutureBuilder(
        future: getUser(),
        builder: (ctx, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting){
            showProgressWidget(context);
          }

          else if (snapshot.connectionState == ConnectionState.done){

            if (!snapshot.hasData){
              //gotoLandingScreen();

            } else if (snapshot.hasData){

              final user_data = snapshot.data!;
              print(user_data);

              return Scaffold(
                  backgroundColor: colorPrimary,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: colorPrimary,
                    foregroundColor: colorSecondary,
                    title: SizedBox(
                      height: 32,
                      child: Image.asset("assets/images/logo.png"),
                    ),
                    //centerTitle: true,
                    actions: [
                      IconButton(
                          onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CartScreen()
                                )
                            );
                          },
                          icon: const Icon(Icons.shopping_bag_outlined)
                      ),
                      IconButton(
                          onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrdersScreen()
                                )
                            );
                          },
                          icon: const Icon(Icons.receipt)
                      ),
                    ],
                  ),
                  drawer: Container(
                    width: width * 0.5,
                    child: Drawer(
                      backgroundColor: colorPrimary,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 48,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text('${user_data!.first_name.toString()} ${user_data!.last_name.toString()}'.toUpperCase(),
                                style: TextStyle(
                                    color: colorSecondary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18
                                )
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text("Edit Profile",
                              style: TextStyle(
                                  color: colorAccent,
                                  fontSize: 10
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Divider(
                            height: 2,
                            color: colorSecondary,
                          ),
                          ListTile(
                            leading: Icon(Icons.chat, color: colorSecondary),
                            title: Text("Chats",
                                style: TextStyle(
                                    color: colorSecondary
                                )
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.help_center, color: colorSecondary),
                            title: Text("Help",
                                style: TextStyle(
                                    color: colorSecondary
                                )),
                          ),
                          ListTile(
                            leading: Icon(Icons.settings, color: colorSecondary),
                            title: Text("Settings",
                                style: TextStyle(
                                    color: colorSecondary
                                )
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.info, color: colorSecondary),
                            title: Text("About",
                                style: TextStyle(
                                    color: colorSecondary
                                )),
                          ),


                        ],
                      ),
                    ),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          TextField(
                            readOnly: true,
                            controller: storeController,
                            onChanged: (value) {
                              selected_store = value.trim();
                            },
                            cursorColor: colorAccent,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: border_radius
                                ),
                                hintText: "Please select store",
                                labelText: 'Store',
                                isDense: true,
                                // Added this
                                contentPadding: const EdgeInsets.all(8)),
                            onTap: (){

                            },
                          ),

                          const SizedBox(height: 4),
                          TextField(
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
                                contentPadding: const EdgeInsets.all(8)),
                            onTap: (){
                              // Search Address
                              showAddressPickerDialog(context, addressController);
                            },
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 32,
                            child: ListView.builder(
                              itemCount: dishCategories.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, i) => Center(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _active = i;
                                      print(_active);
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 8,
                                    ),
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      color: i == _active ? colorAccent : null,
                                      borderRadius: border_radius,
                                    ),
                                    child: Text(
                                      "${dishCategories[i].toUpperCase()}",
                                      style: TextStyle(
                                        color: i == _active ? colorPrimary : null,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 4),
                          SizedBox(height: 500,
                              child: FutureBuilder(
                                future: getProducts(_active),
                                builder: (ctx, snapshot){
                                  if (snapshot.connectionState == ConnectionState.waiting){
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: colorAccent,
                                      ),
                                    );
                                  } else if (snapshot.connectionState == ConnectionState.done){

                                    if (snapshot.hasData){
                                      final productsData = snapshot.data!;

                                      return GridView(
                                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            //crossAxisSpacing: 10.0,
                                            //mainAxisSpacing: 10,
                                          ),
                                          children: productsData.map((e){
                                            return ProductWidget(e);
                                          }).toList());
                                    }
                                  }

                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: colorAccent,
                                    ),
                                  );
                                },
                              )
                          ),
                        ]
                    ),
                  )

              );

            } else if (snapshot.hasError){
              return Container(
                child: Center(
                  child: Text(snapshot.error.toString()),
                ),
              );
            }

          }

          return showProgressWidget(context);
        }
    );
  }

  Future<void> gotoLandingScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', '');
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => LandingScreen()), (Route route) => false);
  }
}
