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
                color: Colors.amber[100], // Amber Textfarbe
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
              backgroundColor: Colors.amber[100], // Hintergrundfarbe für den Button
              foregroundColor: Colors.grey[900],   // Textfarbe für den Button
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Padding für den Button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Abgerundete Ecken
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
