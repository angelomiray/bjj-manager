import 'dart:core';

import 'package:final_project/dao/user_dao.dart';
import 'package:final_project/model/competitor.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class Fight {
  String id;
  String champId;
  int number;
  String idFighter1;
  String idFighter2;
  String belt;
  String idWinner = '-1';
  int pointsFigther1 = 0;
  int pointsFigther2 = 0;
  int advantagesFighter1 = 0;
  int advantagesFighter2 = 0;
  int penaltiesFighter1 = 0;
  int penaltiesFighter = 0;

  Fight({
    required this.id,
    required this.champId,
    required this.number,
    required this.idFighter1,
    required this.idFighter2,
    required this.belt,
    required this.idWinner,
  });

  factory Fight.fromJson(String key, Map<String, dynamic> json) {
    UserDAO dao = UserDAO();

    return Fight(
      id: key,
      champId: json['champId'] as String,
      number: json['number'] as int,
      belt: json['belt'] as String,
      idFighter1: json['idFighter1'],
      idFighter2: json['idFighter2'],
      idWinner: json['idWinner'],
    );
  }

  void setId(String key) {
    id = key;
  }
}
