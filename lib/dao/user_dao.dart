import 'dart:convert';

import 'package:final_project/model/championship.dart';
import 'package:final_project/model/competitor.dart';
import 'package:final_project/model/enterprise.dart';
import 'package:final_project/model/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserDAO with ChangeNotifier {
  // Instância única da classe UserDAO
  static final UserDAO _instance = UserDAO._internal();
  final _baseUrl = 'https://bjj-manager-4a147-default-rtdb.firebaseio.com/';
  final List<User> _users = [];
  late User currentUser;

  // Construtor privado para garantir que não seja possível criar instâncias diretamente
  UserDAO._internal() {
    fetchUsers();
  }

  void setCurrentUser(User u) {
    currentUser = u;
  }

  // Fábrica para obter a instância única da classe UserDAO
  factory UserDAO() {
    return _instance;
  }

  Future<void> addUser(User user) {
    final future = http.post(Uri.parse('$_baseUrl/users.json'),
        body: user is Competitor
            ? jsonEncode({
                "name": user.name,
                "lastName": user.lastName,
                "email": user.email,
                "password": user.password,
                "description": user.description,
                "age": user.age,
                "imgUrl": user.imgUrl,
                "weight": user.weight,
                "belt": user.belt,
              })
            : user is Enterprise
                ? jsonEncode({
                    "name": user.name,
                    "cnpj": user.cnpj,
                    "email": user.email,
                    "password": user.password,
                    "description": user.description,
                    "address": user.address,
                    "imgUrl": user.imgUrl,
                    "phone": user.phone,
                  })
                : null);
    return future.then((response) {
      user.setId(jsonDecode(response.body)['name']);
      _users.add(user);
      notifyListeners();
    });
    // print('executa em sequencia');
  }

  Future<void> saveUser(Map<String, Object> data) {
    bool hasId = data['id'] != '-1';
    bool isCompetitor = data['age'] != null;
    final user;

    if (isCompetitor) {
      user = Competitor(
        id: data['id'] as String,
        email: data['email'] as String,
        password: data['password'] as String,
        description: data['description'] as String,
        name: data['name'] as String,
        lastName: data['lastName'] as String,
        age: data['age'] as int,
        weight: data['weight'] as double,
        belt: data['belt'] as String,
        imgUrl: data['imgUrl'] as String,
      );
    } else {
      user = Enterprise(
        id: data['id'] as String,
        email: data['email'] as String,
        password: data['password'] as String,
        description: data['description'] as String,
        name: data['name'] as String,
        cnpj: data['cnpj'] as String,
        phone: data['phone'] as String,
        address: data['address'] as String,
        imgUrl: data['imgUrl'] as String,
      );
    }

    if (hasId) {
      return updateUser(user);
    } else {
      return addUser(user);
    }
  }

  Future<void> updateUser(User user) {
    int index = _users.indexWhere((p) => p.id == user.id);

    if (index >= 0) {
      _users[index] = user;
      notifyListeners();
    }
    print('aqui');
    http.patch(Uri.parse('$_baseUrl/users/${_users[index].id}.json'),
        body: user is Competitor
            ? jsonEncode({
                "name": user.name,
                "lastName": user.lastName,
                "email": user.email,
                "password": user.password,
                "description": user.description,
                "age": user.age,
                "imgUrl": user.imgUrl,
                "weight": user.weight,
                "belt": user.belt,                
              })
            : user is Enterprise
                ? jsonEncode({
                    "name": user.name,
                    "cnpj": user.cnpj,
                    "email": user.email,
                    "password": user.password,
                    "description": user.description,
                    "address": user.address,
                    "imgUrl": user.imgUrl,
                    "phone": user.phone,
                  })
                : null);

    return Future.value();
  }

  void removeUser(User user) {
    int index = _users.indexWhere((p) => p.email == user.email);

    if (index >= 0) {
      _users.removeWhere((p) => p.email == user.email);
      notifyListeners();
    }

    http.delete(Uri.parse('$_baseUrl/users/${_users[index].email}.json'));
  }

  Future<User?> getUserFromServer(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/users/$id.json'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data.isNotEmpty) {
        User user = User(
          id: '-1',
          email: "email@email.com",
          password: "-1",
          name: "not defined",
          description: "not defined",
          imgUrl:
              'https://www.shutterstock.com/image-vector/profile-photo-vector-placeholder-pic-260nw-535853263.jpg',
        );

        data.forEach((key, value) {
          if (value['lastName'] == null) {
            user = Enterprise.fromJson(key, value);
          } else {
            user = Competitor.fromJson(key, value);
          }
        });

        return user;
      }
    }

    // Se algo der errado ou não houver dados, retorne null
    return null;
  }

  Competitor getComp(String id) {
    int index = _users.indexWhere((p) => p.id == id);

    print(index);

    return _users[index] as Competitor;
  }

  List<Competitor> getCompetitors(List<String> ids) {
    List<Competitor> ret = [];

    for (int i = 0; i < ids.length; ++i) {
      ret.add(getComp(ids[i]));
    }

    return ret;
  }

  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('$_baseUrl/users.json'));

    if (response.statusCode == 200) {
      _users.clear();
      print('here2');
      if (json.decode(response.body) != null) {
        final Map<String, dynamic> data = json.decode(response.body);
        data.forEach((key, value) {
          if (value['lastName'] == null) {
            User enterprise = Enterprise.fromJson(key, value);
            _users.add(enterprise);
          } else {
            User competitor = Competitor.fromJson(key, value);
            _users.add(competitor);
          }
        });
      }
      _users.add(Competitor(
          id: '-1',
          email: "email@email.com",
          password: "-1",
          name: "not defined",
          lastName: "not defined",
          imgUrl:
              "https://www.shutterstock.com/image-vector/profile-photo-vector-placeholder-pic-260nw-535853263.jpg",
          age: 99,
          weight: 99,
          description: "not defined",
          belt: 'not defined'));
      notifyListeners();
      return _users;
    } else {
      throw Exception('Falha ao carregar users');
    }
  }

  bool checkEmail(String email) {
    // final response = await http.get(
    //   Uri.parse('$_baseUrl/$email'),
    // );

    return _users.any((user) => user.email == email);
  }

  User tryLogin(String email, String pw) {
    final result = _users.firstWhere(
        (user) =>
            user.email == email && user.password == user.calculateSHA256(pw),
        orElse: () => User(
            imgUrl:
                "https://www.shutterstock.com/image-vector/profile-photo-vector-placeholder-pic-260nw-535853263.jpg",
            id: '-1',
            email: 'null',
            name: 'null',
            password: 'null',
            description: 'null')); //nao deixou retornar null nem com o User?

    if (result.email != 'null') {
      currentUser = result;
      //todo: dar o update.
      print('here');
    }

    return result;
  }
}
