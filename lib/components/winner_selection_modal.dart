import 'package:flutter/material.dart';
import 'package:final_project/model/competitor.dart'; // Assuming you have a Competitor class

class WinnerSelectionModal extends StatefulWidget {
  final Competitor comp1;
  final Competitor comp2;
  final Function(Competitor) onWinnerSelected;

  WinnerSelectionModal({
    required this.comp1,
    required this.comp2,
    required this.onWinnerSelected,
  });

  @override
  _WinnerSelectionModalState createState() => _WinnerSelectionModalState();
}

class _WinnerSelectionModalState extends State<WinnerSelectionModal> {
  late Competitor _selectedWinner;

  @override
  void initState() {
    super.initState();
    // Initialize the selected winner with comp1 by default
    _selectedWinner = widget.comp1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCompetitorSelection(widget.comp1),
          _buildCompetitorSelection(widget.comp2),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              widget.onWinnerSelected(_selectedWinner);
            },
            child: Text('Definir Vencedor'),
          ),
        ],
      ),
    );
  }

  Widget _buildCompetitorSelection(Competitor competitor) {
    return ListTile(
      title: Text(competitor.name),
      subtitle: Text("KMR"),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(competitor.imgUrl),
      ),
      trailing: Radio(
        value: competitor,
        groupValue: _selectedWinner,
        onChanged: (Competitor? value) {
          setState(() {            
            _selectedWinner = value!;
          });
        },
      ),
    );
  }
}
