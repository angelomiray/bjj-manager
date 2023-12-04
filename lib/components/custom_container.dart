import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  // final IconData icon;
  final String urlImg;
  final String title;
  final Color color;

  CustomContainer(
      {required this.urlImg, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 125,
      height: 125,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20), // Borda arredondada
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              urlImg, // URL da imagem
              width: 90,
              height: 65, // Tamanho da imagem
              // color: Colors.white, // Cor da imagem (opcional)
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white), // Cor do título
            ),
          ],
        ),
      ),
    );
  }
}
