import 'package:final_project/components/competitor_container.dart';
import 'package:final_project/components/winner_selection_modal.dart';
import 'package:final_project/dao/fights_dao.dart';
import 'package:final_project/dao/user_dao.dart';
import 'package:final_project/model/championship.dart';
import 'package:final_project/model/competitor.dart';
import 'package:final_project/model/fight.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FightComponent extends StatelessWidget {
  final Fight fight;
  final Championship champ;
  const FightComponent({super.key, required this.fight, required this.champ});

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<UserDAO>(context);
    final fights = Provider.of<FightsDAO>(context);
    int number = (fight.number == 0 || fight.number == 1) ? 4 : 5;
    bool isCreator = champ.creator.email == users.currentUser.email;

    void checkWinner(int number) {}

    void _showWinnerSelectionModal(BuildContext context, Fight fight) {
      showModalBottomSheet(
        context: context,
        builder: (context) => WinnerSelectionModal(
          comp1: users.getComp(fight.idFighter1),
          comp2: users.getComp(fight.idFighter2),
          onWinnerSelected: (Competitor selectedWinner) {
            fight.idWinner = selectedWinner.id;
            fights.updateFight(fight);

            if (fight.number == 0) {
              Fight f = fights.getFightByDivision(champ.id, fight.belt, 4);
              f.idFighter1 = fight.idWinner;
              fights.updateFight(f);
            } else if (fight.number == 1) {
              Fight f = fights.getFightByDivision(champ.id, fight.belt, 4);
              f.idFighter2 = fight.idWinner;
              fights.updateFight(f);
            } else if (fight.number == 2) {
              Fight f = fights.getFightByDivision(champ.id, fight.belt, 5);
              f.idFighter1 = fight.idWinner;
              fights.updateFight(f);
            } else if (fight.number == 3) {
              Fight f = fights.getFightByDivision(champ.id, fight.belt, 5);
              f.idFighter2 = fight.idWinner;
              fights.updateFight(f);
            } else if (number == 4) {
              Fight f = fights.getFightByDivision(champ.id, fight.belt, 6);
              f.idFighter1 = fight.idWinner;
              fights.updateFight(f);
            } else if (number == 5) {
              Fight f = fights.getFightByDivision(champ.id, fight.belt, 6);
              f.idFighter2 = fight.idWinner;
              fights.updateFight(f);
            }

            Navigator.pop(context);
          },
        ),
      );
    }

    return Row(
      //here
      children: [
        InkWell(
          onTap: () {
            if (isCreator) {
              _showWinnerSelectionModal(
                  context,
                  fights.getFightByDivision(
                      champ.id, fight.belt, fight.number));
            }
          },
          child: Column(
            children: [
              CompetitorContainer(
                competitor: users.getComp(fight.idFighter1),
                winner: fight.idWinner == fight.idFighter1 &&
                    fight.idFighter1 != '-1',
              ),
              CompetitorContainer(
                competitor: users.getComp(fight.idFighter2),
                winner: fight.idWinner == fight.idFighter2 &&
                    fight.idFighter1 != '-1',
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        InkWell(
          onTap: () {
            if (isCreator) {
              _showWinnerSelectionModal(context,
                  fights.getFightByDivision(champ.id, fight.belt, number));
            }
          },
          child: CompetitorContainer(
            competitor: users.getComp(fight.idWinner),
            winner: users.getComp(fight.idWinner).id ==
                    fights
                        .getFightByDivision(champ.id, fight.belt, number)
                        .idWinner &&
                users.getComp(fight.idWinner).id != '-1',
          ),
        ),
      ],
    );
  }
}
