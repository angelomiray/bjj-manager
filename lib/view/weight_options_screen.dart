import 'package:final_project/components/custom_container.dart';
import 'package:final_project/utils/app_routes.dart';
import 'package:flutter/material.dart';

class WeightOptionsScreen extends StatelessWidget {
  const WeightOptionsScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final weight = [
      "Galo (57.5)",
      "Pluma (64.0)",
      "Pena (70.0)",
      "Leve (76.0)",
      "Médio (82.3)",
      "Meio-pesado (88.3)",
      "Pesado (94.3)",
      "Super pesado (100.5)",
      "Pesadíssimo",
      "Absoluto"
    ];
    final images = [
      "https://cdn-icons-png.flaticon.com/512/1665/1665032.png",
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Pesos')),
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
              "Selecione o peso da categoria desejada",
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
              itemCount: weight.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(AppRoutes.BRACKETS_SCREEN);
                  },
                  child: CustomContainer(
                    urlImg: images[0],
                    title: weight[index],
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
