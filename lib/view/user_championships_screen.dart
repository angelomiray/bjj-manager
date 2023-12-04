import 'package:final_project/components/user_championship_component.dart';
import 'package:final_project/dao/championship_dao.dart';
import 'package:final_project/dao/user_dao.dart';
import 'package:final_project/model/enterprise.dart';
import 'package:final_project/model/user.dart';
import 'package:final_project/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserChampionshipsScreen extends StatefulWidget {
  const UserChampionshipsScreen({super.key});

  @override
  State<UserChampionshipsScreen> createState() =>
      _UserChampionshipScreesnState();
}

class _UserChampionshipScreesnState extends State<UserChampionshipsScreen> {
  bool isEnterprise(User u) {
    return u is Enterprise;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDAO>(context).currentUser;

    return Scaffold(
        appBar: AppBar(
          title: Text('Campeonatos'),
          actions: <Widget>[
            Visibility(
              visible: isEnterprise(user),
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AppRoutes.CHAMPIONSHIP_FORM_SCREEN);
                },
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'BLACK',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'BELT',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  "Seus próximos campeonatos",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  height: 50,
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(34, 37, 44, 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.search,
                          color: Color.fromRGBO(63, 64, 69, 1),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: Colors.white),
                            hintText: 'Buscar',
                            hintStyle:
                                TextStyle(fontSize: 14, color: Colors.grey),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(color: Colors.white),
                          onSubmitted: (String value) {
                            //apenas recarrega o widget abaixo.
                            // Navigator.of(context).pushNamed(AppRoutes.SEARCH_SCREEN,
                            //     arguments: value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                Consumer<ChampionshipDAO>(
                  builder: (context, champ, child) {
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: champ.size(),
                      itemBuilder: (BuildContext context, int index) {
                        return UserChampionshipComponent(
                          champ: champ.getChampionship(index),
                        );
                      },
                    );
                  },
                ),
                //               ListView.builder(

                // itemCount: user.champs.length,
              ],
            ),
          ),
        ));
  }
}
