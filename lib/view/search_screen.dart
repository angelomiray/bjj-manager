import 'dart:ui';

import 'package:final_project/components/user_drawer.dart';
import 'package:final_project/dao/championship_dao.dart';
import 'package:final_project/dao/user_dao.dart';
import 'package:final_project/model/championship.dart';
import 'package:final_project/utils/app_routes.dart';
import 'package:final_project/view/championship_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // final searchController = TextFieldController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ModalRoute.of(context)!.settings.arguments as String;
    final champs =
        Provider.of<ChampionshipDAO>(context).listBySimilarity(query);

    return Scaffold(
      drawer: const UserDrawer(),
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        title: const Text('Resultados'),
        elevation: 0,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
      ),
      body: Padding(
          padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  height: 50,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(34, 37, 44, 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.search,
                          color: Color.fromRGBO(63, 64, 69, 1),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(color: Colors.white),
                            hintText: 'Buscar',
                            hintStyle:
                                TextStyle(fontSize: 14, color: Colors.grey),
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(color: Colors.white),
                          onSubmitted: (String value) {
                            Navigator.pop(context);
                            Navigator.of(context).pushNamed(
                                AppRoutes.SEARCH_SCREEN,
                                arguments: value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  physics:
                      const NeverScrollableScrollPhysics(), // Impede a rolagem da lista
                  shrinkWrap: true, // Permite que a lista se ajuste ao conteúdo
                  itemCount: champs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                ChampionshipDetailsScreen(champ: champs[index]),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(34, 37, 44, 1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 100, // Largura desejada
                            height: 100, // Altura desejada
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  25), // Metade da largura/altura para fazer um círculo
                              child: Image.network(
                                champs[index].imgUrl,
                                fit: BoxFit
                                    .cover, // Ajuste da imagem (pode ser alterado conforme necessário)
                              ),
                            ),
                          ),
                          title: Container(
                            margin: const EdgeInsets.only(bottom: 7),
                            child: Text(champs[index].name,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(color: Colors.white)),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(champs[index].startDate,
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                              SizedBox(width: 15),
                              Row(
                                children: [
                                  Icon(Icons.group,
                                      color: Colors.grey, size: 16),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      champs[index]
                                          .competitors
                                          .length
                                          .toString(),
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          )),
    );
  }
}
