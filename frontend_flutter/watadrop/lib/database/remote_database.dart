import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watadrop/orders/models/order.dart';

import '../common/strings.dart';
import '../common/style.dart';
import '../config/location_permissions.dart';
import '../home/models/product.dart';
import '../home/models/store.dart';
import '../user/models/user.dart';
import '../widgets/toast_widget.dart';
var baseUrl = 'https://watadrop.up.railway.app/api';
//var baseUrl = 'http://127.0.0.1:8000/api';
var registerUrl =  baseUrl + "/register/";
var loginUrl =  baseUrl + "/login/";
var tokenUrl =  baseUrl + "/api-token-auth/";
var storesUrl = baseUrl + '/getstores/';
var menuUrl = baseUrl + '/getmenu/';
var userUrl = baseUrl + '/user/';
var getuserUrl = baseUrl + '/getuser/';
var categoryUrl = baseUrl + '/getcategories/';
var productsUrl = baseUrl + '/getproducts/';
var orderUrl = baseUrl + '/order/';
var getordersUrl = baseUrl + '/getorders/';

List<Store> stores = [];

Future<User?> getUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  current_email = prefs.getString('email');

  if (current_email != null){

    final response = await http
        .get(Uri.parse(getuserUrl)
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var responseData = json.decode(response.body);
      for (var singleCollection in responseData){
        User user = User(
          id: singleCollection['id'],
          first_name: singleCollection['first_name'],
          last_name: singleCollection['last_name'],
          email: singleCollection['email'],
        );
        if (user.email.toString() == current_email){
          current_user = user;
          print(current_user);
        }
      }

      return current_user;

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(showToastWidget("Failed to load user", colorFailed));
    }
  }
}

Future<List<Store>> getStores(context,delivery_address) async {


  final response = await http
      .get(Uri.parse(storesUrl)
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    var responseData = json.decode(response.body);
    for (var data in responseData){
      print('store_address: '+data['address']!);
      Future<String> distanceFuture =  getDistance(context,data['address']!.toString(), delivery_address!);
      String distance = await distanceFuture!;

      print(distance);

      Store store = Store(
          id: data['id'],
          name: data['name'],
          address: data['address'],
          phone: data['phone'],
          email: data['email'],
          distance: distance
      );
      stores.add(store);
    }

    return stores;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load store');
  }

}

Future<List<Product>> getProducts() async {

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

      products.add(product);

    }
    return products;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load products');
  }
}

Future<List<Order>> getOrders() async {

  List<Order> orders = [];

  final response = await http
      .get(Uri.parse(getordersUrl),
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    var responseData = json.decode(response.body);

    for (var item in responseData){
      Order order = Order(
          id: item['id'],
          customer: item['customer'],
          store: item['store'],
          price: item['price'],
          address: item['address'],
          date: item['date'],
          reference: item['reference'],
          cart: item['cart'],
          comment: (item['comment'] != null)?item['comment']:"",
          status: item['status']
      );

      orders.add(order);

    }
    return orders;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load orders');
  }
}