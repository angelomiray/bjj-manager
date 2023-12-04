import 'package:final_project/model/user.dart';

class Competitor extends User {
  String lastName;
  int age;
  double weight;
  String belt;

  Competitor({
    required super.id,
    required super.email,
    required super.password,
    required super.name,
    required this.lastName,
    required this.age,
    required this.weight,
    required super.description,
    required this.belt,
    required super.imgUrl,
  });

  factory Competitor.fromJson(String key, Map<String, dynamic> json) {
    return Competitor(
      id: key,
      email: json['email'],
      password: json['password'],
      name: json['name'],
      lastName: json['lastName'],
      age: json['age'],
      weight: json['weight'],
      description: json['description'],
      belt: json['belt'],
      imgUrl: json['imgUrl'],
    );
  }
}
