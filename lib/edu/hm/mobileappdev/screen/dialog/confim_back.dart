import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Bist du dir sicher?'),
        content: Text('Möchtest du wirklich zum Hauptmenu zurück?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              context.go('/');
            },
            child: Text('Ja, sicher'),
          ),
        ],
      );
    },
  );
}
