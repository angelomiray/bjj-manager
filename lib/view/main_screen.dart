import 'dart:ui';

import 'package:final_project/components/user_championship_component.dart';
import 'package:final_project/components/user_drawer.dart';
import 'package:final_project/dao/championship_dao.dart';
import 'package:final_project/model/championship.dart';
import 'package:final_project/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
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

  String formatedString(String text, int amount) {
    List<String> words = text.split(' ');

    List<String> groupedWords = [];
    for (int i = 0; i < words.length; i += amount) {
      int endIndex = i + amount;
      if (endIndex > words.length) {
        endIndex = words.length;
      }
      groupedWords.add(words.sublist(i, endIndex).join(' '));
    }

    String result = groupedWords.join('\n');
    return result;
  }

  @override
  Widget build(BuildContext context) {
    // List<Championship> champs =
    //     .getChampionships();

    final provider = Provider.of<ChampionshipDAO>(context);

    final emAlta = provider.getTop3ChampionshipsByAmountParticipants();
    final soon = emAlta.isNotEmpty ? emAlta[0] : '';
    // final emAlta = provider.getTop3ChampionshipsByDate();

    return Scaffold(
      drawer: const UserDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              // Adicione aqui a lógica para abrir o drawer
              Scaffold.of(context).openDrawer();
            },
          );
        }),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                child: const Text(
                  'Busque por \nCompetições',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 20),
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
                        // labelStyle: TextStyle(color: Colors.white),
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: 'Buscar',
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(color: Colors.white),
                      onSubmitted: (String value) {
                        Navigator.of(context).pushNamed(AppRoutes.SEARCH_SCREEN,
                            arguments: value);
                      },
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Categorias',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              Container(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: TabBar(
                    // isScrollable: true,
                    controller: _tabController,
                    labelPadding: const EdgeInsets.only(right: 20),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    indicator: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    indicatorPadding: const EdgeInsets.symmetric(vertical: 8),
                    tabs: const [
                      Tab(
                        child: Text(
                          'Em alta',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Próximos',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Novos',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Anteriores',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              SingleChildScrollView(
                child: Container(
                  width: double.maxFinite,
                  height: 265,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ListView.builder(
                        scrollDirection: Axis
                            .horizontal, // Isso fará com que os itens sejam dispostos horizontalmente
                        itemCount: emAlta.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            width: 200, // Defina a largura adequada
                            margin: const EdgeInsets.only(left: 10, right: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                    25.0), // Apenas o canto superior esquerdo é arredondado
                              ),
                              image: DecorationImage(
                                image: NetworkImage(emAlta[index].imgUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: ClipRect(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 5, sigmaY: 5),
                                      child: Container(
                                        color: Colors.black.withOpacity(
                                            0.5), // Cor de fundo borrada
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        formatedString(emAlta[index].name, 2),
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ListView.builder(
                        scrollDirection: Axis
                            .horizontal, // Isso fará com que os itens sejam dispostos horizontalmente
                        itemCount: emAlta.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            width: 225, // Defina a largura adequada
                            margin: const EdgeInsets.only(left: 10, right: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                    25.0), // Apenas o canto superior esquerdo é arredondado
                              ),
                              image: DecorationImage(
                                image: NetworkImage(emAlta[index].imgUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: ClipRect(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 5, sigmaY: 5),
                                      child: Container(
                                        color: Colors.black.withOpacity(
                                            0.5), // Cor de fundo borrada
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        formatedString(emAlta[index].name, 2),
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ListView.builder(
                        scrollDirection: Axis
                            .horizontal, // Isso fará com que os itens sejam dispostos horizontalmente
                        itemCount: emAlta.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            width: 225, // Defina a largura adequada
                            margin: const EdgeInsets.only(left: 10, right: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                    25.0), // Apenas o canto superior esquerdo é arredondado
                              ),
                              image: DecorationImage(
                                image: NetworkImage(emAlta[index].imgUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: ClipRect(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 5, sigmaY: 5),
                                      child: Container(
                                        color: Colors.black.withOpacity(
                                            0.5), // Cor de fundo borrada
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        formatedString(emAlta[index].name, 2),
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ListView.builder(
                        scrollDirection: Axis
                            .horizontal, // Isso fará com que os itens sejam dispostos horizontalmente
                        itemCount: emAlta.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            width: 225, // Defina a largura adequada
                            margin: const EdgeInsets.only(left: 10, right: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                    25.0), // Apenas o canto superior esquerdo é arredondado
                              ),
                              image: DecorationImage(
                                image: NetworkImage(emAlta[index].imgUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: ClipRect(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 5, sigmaY: 5),
                                      child: Container(
                                        color: Colors.black.withOpacity(
                                            0.5), // Cor de fundo borrada
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        formatedString(emAlta[index].name, 2),
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Em breve',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              provider.size() > 0
                  ? UserChampionshipComponent(champ: soon as Championship)
                  : Container(
                      margin: EdgeInsets.only(top: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Não há competições para mostrar.',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
