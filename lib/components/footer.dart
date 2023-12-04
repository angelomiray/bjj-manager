import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      margin: const EdgeInsets.only(bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Adicione aqui o logo do aplicativo, por exemplo:
          Text(
            'BLACK',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Text(
            'BELT',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pink),
          ),
          const SizedBox(height: 5),
          const Text(
            "Desenvolvido por Ângelo Miranda, na Universidade Federal do Rio Grande do Norte",
            style: TextStyle(
              fontSize: 8,
            ),
          )
        ],
      ),
    );
  }
}
