import 'dart:convert';

class Product{

  int id;
  final int menu_id;
  final int category_id;
  String name;
  String? description;
  final String image;
  final int qty;
  final int volume;
  final int price;
  final int discount;

  Product(
      {required this.id,
        required this.menu_id,
        required this.name,
        required this.image,
        required this.qty,
        required this.volume,
        required this.price,
        required this.discount,
        required this.description,
        required this.category_id,
      });

  Product copyWith({
    int? id,
    int? menu_id,
    int? category_id,
    String? name,
    String? image,
    String? description,
    int? qty,
    int? volume,
    int? price,
    int? discount,
  }){
    return Product(
      id: id ?? this.id,
      menu_id: id ?? this.menu_id,
      category_id: category_id ?? this.category_id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      qty: qty ?? this.qty,
      volume: volume ?? this.volume,
      price: price ?? this.price,
      discount: discount ?? this.discount,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'menu_id': menu_id,
      'category_id': category_id,
      'name': name,
      'description': description,
      'image': image,
      'qty': qty,
      'volume': volume,
      'price': price,
      'discount': discount,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      menu_id: map['menu_id'],
      category_id: map['category_id'],
      name: map['name'],
      description: map['description'],
      image: map['image'],
      qty: map['qty'],
      volume: map['volume'],
      price: map['price'],
      discount: map['discount'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) => Product.fromMap(
      json.decode(source));

}