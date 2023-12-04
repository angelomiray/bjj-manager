import 'package:final_project/model/competitor.dart';
import 'package:flutter/material.dart';

class CompetitorContainer extends StatelessWidget {
  final Competitor competitor;
  final bool winner;
  const CompetitorContainer(
      {super.key, required this.competitor, required this.winner});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 60,
      margin: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10), // Define o raio da borda
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: CircleAvatar(
              backgroundImage: NetworkImage(competitor.imgUrl),
              backgroundColor: Colors.transparent,
              radius: 20, // Ajuste conforme necessário
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                competitor.name,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Kimura',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          winner ? Expanded(
            child:  Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.check_circle,
                color: Colors.amber,
              ),
            ),
          ) : Expanded(
            child:  Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.radio_button_unchecked,
                color: Colors.pink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
