import 'dart:convert';

class Order{

  int id;
  int store_id;
  int quantity;
  int price;
  String address;
  String cart;
  int status;


  Order({
    required this.id,
    required this.store_id,
    required this.quantity,
    required this.price,
    required this.address,
    required this.cart,
    required this.status,

  });

  Order copyWith({
    int? id,
    int? store_id,
    int? quantity,
    int? price,
    String? address,
    String? cart,
    int? status,

  }){
    return Order(
      id: id ?? this.id,
      store_id: store_id ?? this.store_id,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      address: address ?? this.address,
      cart: cart ?? this.cart,
      status: status ?? this.status,

    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'store_id': store_id,
      'quantity': quantity,
      'price': price,
      'address': address,
      'cart': cart,
      'status': status,

    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      store_id: map['store_id'],
      quantity: map['quantity'],
      price: map['price'],
      address: map['address'],
      cart: map['cart'],
      status: map['status'],


    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(
      json.decode(source));

}