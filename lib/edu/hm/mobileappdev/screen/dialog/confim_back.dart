import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Bist du dir sicher?',
          style: TextStyle(color: Colors.amber[100], fontSize: 24, fontWeight: FontWeight.bold),
        ),
        content: Text(
            'Möchtest du wirklich zum Hauptmenü zurück?',
            style: TextStyle(color: Colors.amber[100], fontSize: 20),
      ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(
              'Abbrechen',
              style: TextStyle(
                color: Colors.amber[100],
                fontSize: 18,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              context.go('/');
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.amber[100],
              foregroundColor: Colors.grey[900],
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Ja, sicher',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}
