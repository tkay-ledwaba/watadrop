import 'dart:convert';

class Store{

  int id;
  String name;
  String address;
  String phone;
  String email;

  Store({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
  });

  Store copyWith({
    int? id,
    String? name,
    String? address,
    String? phone,
    String? email,
  }){
    return Store(
        id: id ?? this.id,
        name: name ?? this.name,
        address: address ?? this.address,
        phone: phone ?? this.phone,
        email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
    };
  }

  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      phone: map['phone'],
      email: map['email'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Store.fromJson(String source) => Store.fromMap(
      json.decode(source));

}