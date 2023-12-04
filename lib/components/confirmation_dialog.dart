import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  ConfirmationDialog({
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromRGBO(23, 24, 28, 1),
      title: Text(title, style: TextStyle(color: Colors.white),),
      content: Text(content, style: TextStyle(color: Colors.white),),
      actions: <Widget>[
        TextButton(
          onPressed: onCancel,
          child: Text(
            'Cancelar',            
          ),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text(
            'Confirmar',            
          ),
        ),
      ],
    );
  }
}
