import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  OptionCard(
      {required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromRGBO(34, 37, 44, 1),
      elevation: 4, // Sombreamento
      margin: EdgeInsets.all(8), // Margem para espaçamento
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 48, color: Colors.amber), // Ícone
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ), // Título
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center, 
              
            ), 
          ],
        ),
      ),
    );
  }
}
