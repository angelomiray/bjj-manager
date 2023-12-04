import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:final_project/model/championship.dart';

class User {
  String id;
  String email;
  String password;
  String name;
  String description = '';
  List<Championship> champs = [];
  String imgUrl;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
    required this.description,
    required this.imgUrl,
  });

  void setId(String key) {
    id = key;
  }

  void addChampionship(Championship c) {
    champs.add(c);
  }

  void setEmail(String e) {
    email = e;
  }

  void setPassword(String p) {
    password = calculateSHA256(p);
  }

  String calculateSHA256(String input) {
    Uint8List bytes = Uint8List.fromList(utf8.encode(input));
    Digest digest = sha256.convert(bytes);
    return digest.toString();
  }
}
