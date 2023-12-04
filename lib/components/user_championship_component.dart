import 'package:final_project/model/championship.dart';
import 'package:final_project/utils/app_routes.dart';
import 'package:final_project/view/championship_details_screen.dart';
import 'package:flutter/material.dart';

class UserChampionshipComponent extends StatelessWidget {
  final Championship champ;
  const UserChampionshipComponent({required this.champ});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        tileColor: const Color.fromRGBO(34, 37, 44, 1),
        shape: RoundedRectangleBorder(
          // side: BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            champ.imgUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(champ.name,
            style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
        subtitle: Text(champ.creator.name,
            style: TextStyle(
              color: Colors.white,
            )),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChampionshipDetailsScreen(
                  champ: champ,
                ),
              ),
            );
          },
          child: const Text('Ver'),
        ),
      ),
    );
  }
}
