import 'package:final_project/components/custom_container.dart';
import 'package:final_project/model/championship.dart';
import 'package:final_project/utils/app_routes.dart';
import 'package:final_project/view/age_options_screen.dart';
import 'package:final_project/view/brackets_screen.dart';
import 'package:flutter/material.dart';

class BeltOptionsScreen extends StatelessWidget {
  final Championship? champ;
  const BeltOptionsScreen({Key? key, required this.champ});

  @override
  Widget build(BuildContext context) {
    final belts = ["Branca", "Azul", "Roxa", "Marrom", "Preta"];
    final images = [
      "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c4/BJJ_White_Belt.svg/640px-BJJ_White_Belt.svg.png",
      "https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/GJJ_Blue_Belt.svg/1280px-GJJ_Blue_Belt.svg.png",
      "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/BJJ_Purple_Belt.svg/1200px-BJJ_Purple_Belt.svg.png",
      "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Brown_belt.svg/512px-Brown_belt.svg.png",
      "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/BJJ_BlackBelt.svg/479px-BJJ_BlackBelt.svg.png"
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Faixas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
              "Selecione a faixa da categoria desejada",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
                child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: belts.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BracketsScreen(
                          belt: belts[index],
                          champ: champ,
                        ),
                      ),
                    );
                  },
                  child: CustomContainer(
                    urlImg: images[index],
                    title: belts[index],
                    color: Color.fromRGBO(34, 37, 44, 1),
                  ),
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}
