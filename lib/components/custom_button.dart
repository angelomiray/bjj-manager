import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  CustomButton(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165,
      height: 85,
      // margin: EdgeInsets.all(8), 
      decoration: BoxDecoration(
        color: color,         
        borderRadius: BorderRadius.circular(20), // Borda arredondada
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 25,
              color: Colors.white, // Cor do ícone
            ),
            SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white), // Cor do título
                ),
                // Text(
                //   subtitle,
                //   style: TextStyle(fontSize: 12, color: Colors.grey),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
