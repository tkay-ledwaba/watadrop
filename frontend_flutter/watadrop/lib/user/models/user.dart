import 'dart:convert';

class UserLogin {
  String username;
  String password;

  UserLogin({required this.username, required this.password});

  Map <String, dynamic> toDatabaseJson() => {
    "username": this.username,
    "password": this.password
  };
}



class User{

  int id;
  String first_name;
  String last_name;
  String email;


  User({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.email,

  });

  User copyWith({
    int? id,
    String? first_name,
    String? last_name,
    String? email,

  }){
    return User(
      id: id ?? this.id,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      email: email ?? this.email,

    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'first_name': first_name,
      'last_name': last_name,
      'email': email,

    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      first_name: map['first_name'],
      last_name: map['last_name'],
      email: map['email'],


    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(
      json.decode(source));

}

