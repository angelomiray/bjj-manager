import 'package:final_project/components/custom_container.dart';
import 'package:final_project/utils/app_routes.dart';
import 'package:flutter/material.dart';

class AgeOptionsScreen extends StatelessWidget {
  const AgeOptionsScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final ages = ["Juvenil", "Adulto", "Master 1", "Master 2", "Master 3"];
    final images = [
      "https://cdn-icons-png.flaticon.com/512/410/410235.png",
      "https://cdn-icons-png.flaticon.com/512/2159/2159600.png",
      "https://cdn-icons-png.flaticon.com/256/2267/2267436.png",
      "https://cdn-icons-png.flaticon.com/512/1623/1623791.png",
      "https://cdn2.iconfinder.com/data/icons/japan-60/512/japanese_warrior_samurai_helmet-512.png",
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Faixa Etária')),
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
              "Selecione a faixa etária da categoria desejada",
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
              itemCount: ages.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(AppRoutes.WEIGHT_OPTIONS_SCREEN);
                  },
                  child: CustomContainer(
                    urlImg: images[index],
                    title: ages[index],
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
