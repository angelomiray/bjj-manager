import 'dart:convert';

import 'package:final_project/model/fight.dart';
import 'package:final_project/model/competitor.dart';
import 'package:final_project/model/enterprise.dart';
import 'package:final_project/model/user.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../model/fight.dart';

class FightsDAO with ChangeNotifier {
  static final FightsDAO _instance = FightsDAO._internal();
  final _baseUrl = 'https://bjj-manager-4a147-default-rtdb.firebaseio.com/';

  List<Fight> fights = [];

  FightsDAO._internal() {
    fetchFights();
  }

  factory FightsDAO() {
    return _instance;
  }

  Future<void> createFight(Fight fight) {
    final future = http.post(Uri.parse('$_baseUrl/fights.json'),
        body: jsonEncode({
          "champId": fight.champId,
          "number": fight.number,
          "idFighter1": fight.idFighter1,
          "idFighter2": fight.idFighter2,
          "belt": fight.belt,
          "idWinner": fight.idWinner,
        }));
    return future.then((response) {
      //print('espera a requisição acontecer');
      fight.setId(jsonDecode(response.body)['name']);
      fights.add(fight);
      notifyListeners();
    });
    // print('executa em sequencia');
  }

  Future<void> updateFight(Fight fight) {
    int index = fights.indexWhere((c) => c.id == fight.id);

    if (index >= 0) {
      fights[index] = fight;
      notifyListeners();
    }
    http.patch(Uri.parse('$_baseUrl/fights/${fights[index].id}.json'),
        body: jsonEncode({
          "id": fight.id,
          "champId": fight.champId,
          "number": fight.number,
          "belt": fight.belt,
          "idWinner": fight.idWinner,
          "idFighter1": fight.idFighter1,
          "idFighter2": fight.idFighter2,
        }));

    return Future.value();
  }

  void removeFight(Fight fight) {
    int index = fights.indexWhere((p) => p.id == fight.id);

    print(index);

    if (index >= 0) {
      http.delete(Uri.parse('$_baseUrl/fights/${fights[index].id}.json'));

      fights.removeWhere((p) => p.id == fight.id);
      notifyListeners();
    }
  }

  Future<List<Fight>> fetchFights() async {
    final response = await http.get(Uri.parse('$_baseUrl/fights.json'));
    print('her1');
    if (response.statusCode == 200) {
      if (json.decode(response.body) != null) {
        fights.clear();
        final Map<String, dynamic> data = json.decode(response.body);

        data.forEach((key, value) {
          Fight fight = Fight.fromJson(key, value);
          fights.add(fight);
        });
      }
  
      notifyListeners();
      return fights;
    } else {
      throw Exception('Falha ao carregar camps');
    }
  }

  Future<void> initialize(String champId) async {
    List<String> belts = ['Branca', 'Azul', 'Roxa', 'Marrom', 'Preta'];

    for (int i = 0; i < belts.length; ++i) {
      await initDivision(champId, belts[i]);
    }
  }

  Future<void> initDivision(String champId, String belt) async {
    for (int i = 0; i < 7; ++i) {
      Fight fight = Fight(
          id: '-1',
          champId: champId,
          number: i,
          belt: belt,
          idWinner: '-1',
          idFighter1: '-1',
          idFighter2: '-1');
      await createFight(fight);
    }
  }

  Future<void> generateDivision(
      String champId, List<Competitor> comps, String belt) async {
    int fightNumber = 0;

    for (int i = 0; i < comps.length; ++i) {
      Fight fight = getFightByDivision(champId, belt,
          fightNumber); //sempre vai dar certo por conta do initialize()

      if (i % 2 == 0) {
        fight.idFighter1 = comps[i].id;
      } else {
        fight.idFighter2 = comps[i].id;
        fightNumber++;
      }

      await updateFight(fight);
    }
  }

  Future<void> generateBrackets(String champId, List<Competitor> comps) async {
    List<Competitor> whites = [];
    List<Competitor> blues = [];
    List<Competitor> purples = [];
    List<Competitor> browns = [];
    List<Competitor> blacks = [];

    for (int i = 0; i < comps.length; ++i) {
      if (comps[i].belt == 'Branca') {
        whites.add(comps[i]);
      } else if (comps[i].belt == 'Azul') {
        blues.add(comps[i]);
      } else if (comps[i].belt == 'Roxa') {
        purples.add(comps[i]);
      } else if (comps[i].belt == 'Marrom') {
        browns.add(comps[i]);
      } else {
        blacks.add(comps[i]);
      }
    }

    generateDivision(champId, whites, 'Branca');
    generateDivision(champId, blues, 'Azul');
    generateDivision(champId, purples, 'Roxa');
    generateDivision(champId, whites, 'Marrom');
    generateDivision(champId, blacks, 'Preta');
  }

  Fight getFightByDivision(String champId, String belt, int number) {
    for (int i = 0; i < fights.length; ++i) {
      if (fights[i].champId == champId &&
          fights[i].belt == belt &&
          fights[i].number == number) {
        return fights[i];
      }
    }

    return Fight(
        idWinner: '-1',
        id: '-1',
        champId: '-1',
        number: 0,
        idFighter1: '-1',
        idFighter2: '-1',
        belt: belt);
  }

  Fight getFight(int index) {
    return fights[index];
  }

  List<Fight> getFights() {
    return fights;
  }
}
