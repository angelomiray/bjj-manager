import 'dart:convert';

import 'package:final_project/model/user.dart';

class Enterprise extends User {
  String cnpj;
  String address;
  String phone;

  Enterprise(
      {required super.id,
      required super.email,
      required super.name,
      required this.cnpj,
      required this.address,
      required this.phone,
      required super.password,
      required super.imgUrl,
      required super.description});

  factory Enterprise.fromJson(String key, Map<String, dynamic> json) {
    return Enterprise(
      id: key,
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      cnpj: json['cnpj'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      description: json['description'] as String,
      imgUrl: json['imgUrl'] as String,
    );
  }

  static Enterprise enterpriseFromJsonString(String jsonString) {
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    return Enterprise.fromJson('', jsonMap);
  }
}
