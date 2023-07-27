import 'dart:convert';

class Order{

  int id;
  int customer;
  int store;
  int price;
  String address;
  String date;
  String reference;
  String cart;
  int status;

  Order({
    required this.id,
    required this.customer,
    required this.store,
    required this.price,
    required this.address,
    required this.date,
    required this.reference,
    required this.cart,
    required this.status,
  });

  Order copyWith({
    int? id,
    int? customer,
    int? store,
    int? price,
    String? address,
    String? date,
    String? reference,
    String? cart,
    int? status,
  }){
    return Order(
      id: id ?? this.id,
      customer: customer ?? this.customer,
      store: store ?? this.store,
      price: price ?? this.price,
      address: address ?? this.address,
      date: date ?? this.date,
      reference: reference ?? this.reference,
      cart: cart ?? this.cart,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'customer': customer,
      'store': store,
      'price': price,
      'address': address,
      'date': date,
      'reference': reference,
      'cart': cart,
      'status': status,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      customer: map['customer'],
      store: map['store'],
      price: map['price'],
      address: map['address'],
      date: map['date'],
      reference: map['reference'],
      cart: map['cart'],
      status: map['status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(
      json.decode(source));

}