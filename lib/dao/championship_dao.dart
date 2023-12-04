import 'dart:convert';

import 'package:final_project/dao/user_dao.dart';
import 'package:final_project/model/championship.dart';
import 'package:final_project/model/competitor.dart';
import 'package:final_project/model/enterprise.dart';
import 'package:final_project/model/user.dart';
import 'package:final_project/utils/db_util.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class ChampionshipDAO with ChangeNotifier {
  static final ChampionshipDAO _instance = ChampionshipDAO._internal();
  final _baseUrl = 'https://bjj-manager-4a147-default-rtdb.firebaseio.com/';

  final List<Championship> _championships = [];
  List<Championship> _localData = [];

  ChampionshipDAO._internal() {
    fetchChampionships();
  }

  factory ChampionshipDAO() {
    return _instance;
  }

  // Future<void> loadLocalData() async {
  //   final dao = UserDAO();

  //   final dataList = await DbUtil.getData('places');
  //   _localData.clear();
  //   _localData = dataList
  //       .map((item) => Championship(
  //           id: item['id'],
  //           name: item['name'],
  //           description: item['description'],
  //           location: item['location'],
  //           creator: dao.getUserFromServer(item['id']) as Enterprise,
  //           price: item['price'],
  //           imgUrl: item['imgUrl'],
  //           startDate: item['startDate'],
  //           endDate: item['endDate'],
  //           competitors: dao.getCompetitors(
  //               List<String>.from(json.decode(item['competitors']))),
  //           bracketsGenerated: item['bracketsGenerated'],
  //           lat: item['lat'],
  //           lng: item['lng']))
  //       .toList();
  //   notifyListeners();
  // }

  // Future<void> synchronizeLocalData() {
  //   final lastFiveItems = _championships.length >= 5
  //       ? _championships.sublist(_championships.length - 5)
  //       : [..._championships];

  //   _localData.clear();
  //   DbUtil.deleteAllItems('championships');
  //   for (int i = 0; i < lastFiveItems.length; ++i) {
  //     DbUtil.insert('championships', {
  //       "name": lastFiveItems[i].name,
  //       "description": lastFiveItems[i].description,
  //       "location": lastFiveItems[i].location,
  //       "startDate": lastFiveItems[i].startDate,
  //       "endDate": lastFiveItems[i].endDate,
  //       "price": lastFiveItems[i].price,
  //       "imgUrl": lastFiveItems[i].imgUrl,
  //       "bracketsGenerated": false,
  //       "competitors": ['-1'],
  //       "lat": lastFiveItems[i].lat,
  //       "lng": lastFiveItems[i].lng,
  //       "creator": jsonEncode({
  //         "name": lastFiveItems[i].creator.name,
  //         "cnpj": lastFiveItems[i].creator.cnpj,
  //         "email": lastFiveItems[i].creator.email,
  //         "password": lastFiveItems[i].creator.password,
  //         "description": lastFiveItems[i].creator.description,
  //         "address": lastFiveItems[i].creator.address,
  //         "imgUrl": lastFiveItems[i].creator.imgUrl,
  //         "phone": lastFiveItems[i].creator.phone,
  //       })
  //     });
  //     _localData.add(lastFiveItems[i]);
  //   }

  //   notifyListeners();
  //   return Future.value();
  // }

  Future<void> createChampionship(Championship champ) {
    final future = http.post(Uri.parse('$_baseUrl/championships.json'),
        body: jsonEncode({
          "name": champ.name,
          "description": champ.description,
          "location": champ.location,
          "startDate": champ.startDate,
          "endDate": champ.endDate,
          "price": champ.price,
          "imgUrl": champ.imgUrl,
          "bracketsGenerated": false,
          "competitors": ['-1'],
          "lat": champ.lat,
          "lng": champ.lng,
          "creator": jsonEncode({
            "name": champ.creator.name,
            "cnpj": champ.creator.cnpj,
            "email": champ.creator.email,
            "password": champ.creator.password,
            "description": champ.creator.description,
            "address": champ.creator.address,
            "imgUrl": champ.creator.imgUrl,
            "phone": champ.creator.phone,
          }),
        }));
    return future.then((response) {
      //print('espera a requisição acontecer');
      champ.setId(jsonDecode(response.body)['name']);
      _championships.add(champ);

      // DbUtil.insert('championships', {
      //   "name": champ.name,
      //   "description": champ.description,
      //   "location": champ.location,
      //   "startDate": champ.startDate,
      //   "endDate": champ.endDate,
      //   "price": champ.price,
      //   "imgUrl": champ.imgUrl,
      //   "bracketsGenerated": false,
      //   "competitors": ['-1'],
      //   "lat": champ.lat,
      //   "lng": champ.lng,
      //   "creator": jsonEncode({
      //     "name": champ.creator.name,
      //     "cnpj": champ.creator.cnpj,
      //     "email": champ.creator.email,
      //     "password": champ.creator.password,
      //     "description": champ.creator.description,
      //     "address": champ.creator.address,
      //     "imgUrl": champ.creator.imgUrl,
      //     "phone": champ.creator.phone,
      //   })
      // });

      notifyListeners();
    });
    // print('executa em sequencia');
  }

  Future<void> saveChampionship(Map<String, Object> data) {
    bool hasId = data['id'] != '-1';

    UserDAO dao = UserDAO();

    final championship = Championship(
        id: data['id'] as String,
        name: data['name'] as String,
        description: data['description'] as String,
        price: double.parse(data['price'] as String),
        imgUrl: data['imgUrl'] as String,
        location: data['address'] as String,
        startDate: data['startDate'] as String,
        endDate: data['endDate'] as String,
        creator: data['creator'] as Enterprise,
        lat: data['lat'] as double,
        lng: data['lng'] as double,
        bracketsGenerated: data['bracketsGenerated'] as bool,
        competitors: dao.getCompetitors(
          List<String>.from(data['competitors'] as List),
        ));

    if (hasId) {
      return updateChampionship(championship);
    } else {
      return createChampionship(championship);
    }
  }

  Future<void> updateChampionship(Championship champ) {
    int index = _championships.indexWhere((c) => c.id == champ.id);

    if (index >= 0) {
      _championships[index] = champ;
      notifyListeners();
    }
    http.patch(
        Uri.parse('$_baseUrl/championships/${_championships[index].id}.json'),
        body: jsonEncode({
          "id": champ.id,
          "name": champ.name,
          "description": champ.description,
          "location": champ.location,
          "startDate": champ.startDate,
          "endDate": champ.endDate,
          "price": champ.price,
          "imgUrl": champ.imgUrl,
          "lat": champ.lat,
          "lng": champ.lng,
          "bracketsGenerated": champ.bracketsGenerated,
          "competitors": champ.competitors.length > 0
              ? champ.competitors
                  .map((competitor) => competitor.id.toString())
                  .toList()
              : ['-1'],
          "creator": {
            "name": champ.creator.name,
            "cnpj": champ.creator.cnpj,
            "email": champ.creator.email,
            "password": champ.creator.password,
            "description": champ.creator.description,
            "address": champ.creator.address,
            "imgUrl": champ.creator.imgUrl,
            "phone": champ.creator.phone,
          },
        }));

    // DbUtil.updateItem('championships', champ.id, {
    //   "name": champ.name,
    //   "description": champ.description,
    //   "location": champ.location,
    //   "startDate": champ.startDate,
    //   "endDate": champ.endDate,
    //   "price": champ.price,
    //   "imgUrl": champ.imgUrl,
    //   "bracketsGenerated": false,
    //   "competitors": ['-1'],
    //   "lat": champ.lat,
    //   "lng": champ.lng,
    //   "creator": jsonEncode({
    //     "name": champ.creator.name,
    //     "cnpj": champ.creator.cnpj,
    //     "email": champ.creator.email,
    //     "password": champ.creator.password,
    //     "description": champ.creator.description,
    //     "address": champ.creator.address,
    //     "imgUrl": champ.creator.imgUrl,
    //     "phone": champ.creator.phone,
    //   })
    // });

    return Future.value();
  }

  void removeChampionship(Championship championship) {
    int index = _championships.indexWhere((p) => p.id == championship.id);

    print(index);

    if (index >= 0) {
      http.delete(Uri.parse(
          '$_baseUrl/championships/${_championships[index].id}.json'));

      _championships.removeWhere((p) => p.id == championship.id);
      // DbUtil.deleteItem('championships', championship.id);

      notifyListeners();
    }
  }

  Future<List<Championship>> fetchChampionships() async {
    final response = await http.get(Uri.parse('$_baseUrl/championships.json'));
    print('here');
    if (response.statusCode == 200) {
      if (json.decode(response.body) != null) {
        _championships.clear();
        final Map<String, dynamic> data = json.decode(response.body);

        data.forEach((key, value) {
          Championship championship = Championship.fromJson(key, value);
          _championships.add(championship);
        });
      }

      // synchronizeLocalData();
      notifyListeners();
      return _championships;
    } else {
      throw Exception('Falha ao carregar camps');
    }
  }

  void addUserToChamp(Competitor comp, Championship champ) {
    int index = _championships.indexWhere((c) => c.id == champ.id);

    if (index >= 0) {
      _championships[index].addCompetitor(comp);
      updateChampionship(champ);
      notifyListeners();
    }
  }

  void removeUserFromChamp(Competitor comp, Championship champ) {
    int index = _championships.indexWhere((c) => c.id == champ.id);

    if (index >= 0) {
      _championships[index].removeCompetitor(comp);
      updateChampionship(champ);
      notifyListeners();
    }
  }

  List<Championship> getTop3ChampionshipsByAmountParticipants() {
    _championships
        .sort((a, b) => b.competitors.length.compareTo(a.competitors.length));

    return _championships.length > 3
        ? _championships.take(3).toList()
        : _championships;
  }

  List<Championship> getTop3ChampionshipsByDate() {
    _championships.sort((a, b) {
      int participantsComparison =
          b.competitors.length.compareTo(a.competitors.length);
      if (participantsComparison != 0) {
        return participantsComparison;
      }
      return DateTime.parse(b.startDate).compareTo(DateTime.parse(a.startDate));
    });

    return _championships.length > 0 ? _championships.take(3).toList() : [];
  }

  int size() {
    return _championships.length;
  }

  Championship getChampionship(int index) {
    return _championships[index];
  }

  Championship? getChampById(String id) {
    for (int i = 0; i < _championships.length; ++i) {
      if (_championships[i].id == id) {
        return _championships[i];
      }
    }

    return null;
  }

  List<Championship> getChampionships() {
    return _championships;
  }

  double jaccardSimilarity(String s1, String s2) {
    final Set<String> set1 = Set.from(s1.split(''));
    final Set<String> set2 = Set.from(s2.split(''));

    final int intersectionSize = set1.intersection(set2).length;
    final int unionSize = set1.union(set2).length;

    return intersectionSize / unionSize;
  }

  List<Championship> listBySimilarity(String query) {
    List<Championship> list = [..._championships];
    list.sort((a, b) {
      final double similarityA = jaccardSimilarity(query, a.name);
      final double similarityB = jaccardSimilarity(query, b.name);

      return similarityB.compareTo(similarityA);
    });

    return list;
  }
}
