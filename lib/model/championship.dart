import 'dart:io';
import 'dart:convert';

import 'package:final_project/dao/user_dao.dart';
import 'package:final_project/model/competitor.dart';
import 'package:final_project/model/division.dart';
import 'package:final_project/model/enterprise.dart';
import 'package:final_project/model/fight.dart';
import 'package:final_project/model/user.dart';

class Championship {
  String id;
  String name;
  String description;
  String location;
  double lat;
  double lng;
  Enterprise creator;
  String imgUrl = '';
  double price;
  String startDate = "01/01/2001";
  String endDate = "01/01/2001";
  List<Competitor> competitors;
  List<Fight> fightsWhite = [];
  List<Fight> fightsBlue = [];
  List<Fight> fightsPurple = [];
  List<Fight> fightsBrown = [];
  List<Fight> fightsBlack = [];
  bool bracketsGenerated = false;

  Championship({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.creator,
    required this.price,
    required this.imgUrl,
    required this.startDate,
    required this.endDate,
    required this.competitors,
    required this.bracketsGenerated,
    required this.lat,
    required this.lng,
  });

  factory Championship.fromJson(String key, Map<String, dynamic> json) {
    UserDAO dao = UserDAO();

    // Converter lista de IDs de competidores em lista de objetos User

    print(json['competitors'].runtimeType);

    List<dynamic> competitorList = json['competitors'];
    List<String> competitorIds = List<String>.from(competitorList);

    print('here4');
    print(competitorIds[0]);

    List<Competitor> competitors = [];

    for (String competitorId in competitorIds) {
      Competitor competitor = dao.getComp(competitorId);
      competitors.add(competitor);
    }

    print(json['creator']);

    print(json['creator'].runtimeType);

    return Championship(
      id: key,
      name: json['name'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      creator: json['creator'] is String
          ? Enterprise.enterpriseFromJsonString(json['creator'])
          : Enterprise.fromJson('', json['creator']),
      imgUrl: json['imgUrl'] as String,
      price: json['price'] as double,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      bracketsGenerated: json['bracketsGenerated'] as bool,
      lat: json['lat'] as double,
      lng: json['lng'] as double,
      competitors: competitors,
    );
  }

  void addCompetitor(Competitor c) {
    competitors.add(c);
  }

  void removeCompetitor(Competitor c) {
    competitors.remove(c);
  }

  void setId(String key) {
    id = key;
  }
}
