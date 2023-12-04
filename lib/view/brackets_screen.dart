import 'package:final_project/components/competitor_container.dart';
import 'package:final_project/components/custom_button.dart';
import 'package:final_project/components/fight_component.dart';
import 'package:final_project/components/winner_selection_modal.dart';
import 'package:final_project/dao/championship_dao.dart';
import 'package:final_project/dao/fights_dao.dart';
import 'package:final_project/dao/user_dao.dart';
import 'package:final_project/model/championship.dart';
import 'package:final_project/model/competitor.dart';
import 'package:final_project/model/fight.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BracketsScreen extends StatefulWidget {
  final String belt;
  final Championship? champ;

  const BracketsScreen({Key? key, required this.belt, required this.champ})
      : super(key: key);

  @override
  State<BracketsScreen> createState() => _BracketsScreenState();
}

class _BracketsScreenState extends State<BracketsScreen> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<UserDAO>(context);
    final provider = Provider.of<FightsDAO>(context);

    bool isCreator() {
      return widget.champ!.creator.email == users.currentUser.email;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Chave da Competição')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Row(
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
              const SizedBox(height: 5),
              Text(
                widget.belt.toUpperCase(),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Column(
                      children: [
                        FightComponent(
                          fight: provider.getFightByDivision(
                              widget.champ!.id, widget.belt, 0),
                          champ: widget.champ!,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        FightComponent(
                          fight: provider.getFightByDivision(
                              widget.champ!.id, widget.belt, 1),
                          champ: widget.champ!,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        FightComponent(
                            fight: provider.getFightByDivision(
                                widget.champ!.id, widget.belt, 2),
                            champ: widget.champ!),
                        const SizedBox(
                          height: 15,
                        ),
                        FightComponent(
                            fight: provider.getFightByDivision(
                                widget.champ!.id, widget.belt, 3),
                            champ: widget.champ!)
                      ],
                    ),
                    Row(
                      //here
                      children: [
                        InkWell(
                          onTap: () {
                            if (isCreator()) {
                              Fight finalFight = provider.getFightByDivision(
                                  widget.champ!.id, widget.belt, 6);

                              showModalBottomSheet(
                                context: context,
                                builder: (context) => WinnerSelectionModal(
                                  comp1: users.getComp(finalFight.idFighter1),
                                  comp2: users.getComp(finalFight.idFighter2),
                                  onWinnerSelected:
                                      (Competitor selectedWinner) {
                                    finalFight.idWinner = selectedWinner.id;
                                    provider.updateFight(finalFight);

                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            }
                          },
                          child: Column(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              CompetitorContainer(
                                  competitor: users.getComp(provider
                                      .getFightByDivision(
                                          widget.champ!.id, widget.belt, 4)
                                      .idWinner),
                                  winner: users.getComp(provider
                                              .getFightByDivision(
                                                  widget.champ!.id,
                                                  widget.belt,
                                                  4)
                                              .idWinner) ==
                                          users.getComp(provider
                                              .getFightByDivision(
                                                  widget.champ!.id,
                                                  widget.belt,
                                                  6)
                                              .idWinner) &&
                                      users
                                              .getComp(provider
                                                  .getFightByDivision(
                                                      widget.champ!.id,
                                                      widget.belt,
                                                      4)
                                                  .idWinner)
                                              .id !=
                                          '-1'),
                              const SizedBox(
                                height: 225,
                              ),
                              CompetitorContainer(
                                  competitor: users.getComp(provider
                                      .getFightByDivision(
                                          widget.champ!.id, widget.belt, 5)
                                      .idWinner),
                                  winner: users.getComp(provider
                                              .getFightByDivision(
                                                  widget.champ!.id,
                                                  widget.belt,
                                                  5)
                                              .idWinner) ==
                                          users.getComp(provider
                                              .getFightByDivision(
                                                  widget.champ!.id,
                                                  widget.belt,
                                                  6)
                                              .idWinner) &&
                                      users
                                              .getComp(provider
                                                  .getFightByDivision(
                                                      widget.champ!.id,
                                                      widget.belt,
                                                      5)
                                                  .idWinner)
                                              .id !=
                                          '-1'),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        CompetitorContainer(
                          competitor: users.getComp(provider
                              .getFightByDivision(
                                  widget.champ!.id, widget.belt, 6)
                              .idWinner),
                          winner: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                    icon: Icons.add,
                    title: 'Resultado',
                    subtitle: '01/01/2001',
                    color: Colors.amber,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
