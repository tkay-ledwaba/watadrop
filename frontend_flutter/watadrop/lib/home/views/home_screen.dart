import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:watadrop/home/models/product.dart';
import 'package:watadrop/widgets/toast_widget.dart';
import '../../cart/models/cart.dart';
import '../../cart/views/cart_screen.dart';
import '../../common/strings.dart';
import '../../common/style.dart';
import '../../config/location_permissions.dart';
import '../../database/local_database_helper.dart';
import '../../database/remote_database.dart';
import '../../orders/views/orders_screen.dart';
import '../../user/models/user.dart';

import '../../user/views/landing_screen.dart';
import '../../widgets/banner_ad_widget.dart';
import '../../widgets/progress_widget.dart';
import '../models/store.dart';
import '../widgets/address_widget.dart';
import '../widgets/product_widget.dart';
import 'drawer.dart';

final scaffoldKey = GlobalKey<ScaffoldState>();

late BannerAd bannerAd;
bool isAdLoaded = false;
var adUnitId = "ca-app-pub-3940256099942544/6300978111";

DatabaseHelper databaseHelper = DatabaseHelper();
List<Cart> cartList = <Cart>[];
//Cart cart;
int count = 0;

void updateListView() {
  final Future<Database> dbFuture = databaseHelper.initializeDatabase();
  dbFuture.then((database) {
    Future<List<Cart>> cartListFuture = databaseHelper.getCartList();
    cartListFuture.then((list) {
      cartList = list;
      count = list.length;
    });
  });
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Initialize loading if true show progress indicator
  bool isLoading = true;

  String? selected_store;

  Client client = http.Client();

  List<String> menu_options = [
    'Products',
    'Refill',
    //'Subscriptions',
    //'Services'
  ];

  int _active = 0;

  var store_address;
  late Store store_selected;

  var delivery_address;

  TextEditingController storeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String? store;
  String? address;

  List<Product> products = [];
  List<Store> stores = [];

  var display_products = [];

  void initData() {
    getCurrentAddress().then((value) {
      if (mounted) {
        if (value != null) {
          setState(() {
            addressController.text = delivery_address = value.toString();
          });

          getStores(context,delivery_address!).then((store) {
            print('delivery_address: ' + delivery_address);
            if (store.isNotEmpty) {
              setState(() {
                stores = store;
                print('data_store: ' + stores[0].name.toString());
                stores = stores.map((store)=> store).toList()
                  ..sort((a, b) {
                    return a.distance!.compareTo(b.distance!);
                  });
                print(stores);
                print('data_store: ' + stores[0].name.toString());
                store_selected = stores[0];
                storeController.text =
                    '${stores[0].name} (${stores[0].distance}km)';
                isLoading = false;
              });
            }
          });
        } else {
          initData();
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initData();

    getProducts().then((value) {
      if (mounted) {
        if (value.isNotEmpty) {
          setState(() {
            products = value;
            getProductsById(_active + 1);
          });
        }
      }
    });

    _refreshData();
  }

  getProductsById(id) {
    for (int a = 0; a < products.length; a++) {
      setState(() {
        Product product = Product(
          id: products[a].id,
          menu_id: products[a].menu_id,
          name: products[a].name,
          image: products[a].image,
          qty: products[a].qty,
          volume: products[a].volume,
          price: products[a].price,
          discount: products[a].discount,
          description: products[a].description,
          category_id: products[a].category_id,
        );

        if (products[a].menu_id == _active + 1) {
          print('product' + products[a].menu_id.toString());
          display_products.add(product);
        }
      });
    }
  }

  initBannerAd() {
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: adUnitId,
        listener: BannerAdListener(onAdLoaded: (ad) {
          isAdLoaded = true;
          print("Add is loaded");
        }, onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print(error);
        }),
        request: AdRequest());
    bannerAd.load();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    storeController.dispose();
  }

  // This function is used to fetch all data from the database
  void _refreshData() async {
    initBannerAd();
    final data = await databaseHelper.getCartList();
    setState(() {
      cartList = data;
      //isLoading = false;
      count = cartList.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    if (cartList == null) {
      cartList = <Cart>[];
      updateListView();
    }

    int id = 0;

    return FutureBuilder(
        future: getUser(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            showProgressWidget(context);
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasData) {
              gotoLandingScreen();
            } else if (snapshot.hasData) {
              final user_data = snapshot.data!;
              print(user_data.email);
              return (isLoading)
                  ? showProgressWidget(context)
                  : Scaffold(
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
                          Padding(
                              padding:
                                  const EdgeInsets.only(right: 0.0, top: 0),
                              child: GestureDetector(
                                child: Badge(
                                  badgeColor: colorAccent,
                                  showBadge: (count == 0) ? false : true,
                                  position:
                                      BadgePosition.topStart(top: 4, start: 12),
                                  badgeContent: Text(
                                    count.toString(),
                                    style: TextStyle(color: colorPrimary),
                                  ),
                                  child: Icon(
                                    Icons.shopping_bag_outlined,
                                    color: colorSecondary,
                                  ),
                                ),
                                onTap: () {
                                  if (count == 0) {
                                    showToastWidget(
                                        "Your cart is empty, please add something.",
                                        colorSecondary);
                                  } else {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => CartScreen(
                                                selected_store: store_selected,
                                                delivery_address: addressController.text,
                                                distance: stores[0].distance.toString()
                                            )
                                        )
                                    );
                                  }
                                },
                              )),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OrdersScreen()));
                              },
                              icon: const Icon(Icons.receipt)),
                        ],
                      ),
                      drawer: DrawerWidget(context, user_data),
                      body: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  const SizedBox(height: 4),
                                  TextField(
                                    readOnly: true,
                                    controller: addressController,
                                    onChanged: (value) {
                                      address = value.trim();
                                    },
                                    maxLines: 2,
                                    cursorColor: colorAccent,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: border_radius),
                                        hintText: "Please set address",
                                        labelText: 'Delivery Address',
                                        isDense: true,
                                        // Added this
                                        contentPadding:
                                            const EdgeInsets.all(8)),
                                    onTap: () {
                                      // Search Address
                                      showAddressPickerDialog(
                                          context, addressController);
                                      getStores(context,addressController.text!)
                                          .then((store) {
                                        print('delivery_address: ' +
                                            addressController.text);
                                        if (store.isNotEmpty) {
                                          setState(() {
                                            stores = store;
                                            print('data_store: ' +
                                                stores[0].name.toString());
                                            store_selected = stores[0];
                                            storeController.text =
                                                '${stores[0].name}\n(${stores[0].distance}km)';
                                          });
                                        }
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 4),
                                  TextField(
                                    readOnly: true,
                                    controller: storeController,
                                    onChanged: (value) {
                                      selected_store = value.trim();
                                    },
                                    maxLines: 2,
                                    cursorColor: colorAccent,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: border_radius),
                                        hintText: "Please select store",
                                        labelText: 'Store',
                                        isDense: true,
                                        // Added this
                                        contentPadding:
                                            const EdgeInsets.all(8)),
                                    onTap: () {},
                                  )
                                ],
                              ),
                              const SizedBox(height: 4),
                              SizedBox(
                                height: 32,
                                child: ListView.builder(
                                  itemCount: menu_options.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, i) => Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _active = i;
                                          print(
                                              'active: ' + _active.toString());
                                          display_products = [];
                                          getProductsById(_active + 1);
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 7,
                                          vertical: 8,
                                        ),
                                        margin: const EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                          color:
                                              i == _active ? colorAccent : null,
                                          borderRadius: border_radius,
                                        ),
                                        child: Text(
                                          "${menu_options[i].toUpperCase()}",
                                          style: TextStyle(
                                            color: i == _active
                                                ? colorPrimary
                                                : null,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              SizedBox(
                                  height: 500,
                                  child: GridView(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        //crossAxisSpacing: 10.0,
                                        //mainAxisSpacing: 10,
                                      ),
                                      children:
                                          display_products!.map((product) {
                                        return ProductWidget(
                                            context, product, _refreshData);
                                      }).toList())),
                              const SizedBox(height: 50),
                            ]),
                      ),
                      bottomSheet: loadBannerAdWidget(bannerAd, isAdLoaded),
                    );
            } else if (snapshot.hasError) {
              return Container(
                child: Center(
                  child: Text(snapshot.error.toString()),
                ),
              );
            }
          }

          return showProgressWidget(context);
        });
  }

  Future<void> gotoLandingScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', '');
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LandingScreen()),
        (Route route) => false);
  }
}
