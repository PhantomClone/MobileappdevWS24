import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobileappdev/edu.hm.mobileappdev/model/player.dart';
import 'package:provider/provider.dart';

import '../../online/client.dart';
import '../../state/play_state.dart';

joinGameDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final playerNameController = TextEditingController();
      final gameIdController = TextEditingController();

      return AlertDialog(
        title: Text('Enter Player Name & Game ID'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Please enter player name:'),
            TextField(
              controller: playerNameController,
              keyboardType: TextInputType.text,
              maxLength: 15,
              decoration: InputDecoration(
                hintText: 'PlayerName',
                counterText: '',
              ),
            ),
            Text('Please enter exactly 5 digits:'),
            TextField(
              controller: gameIdController,
              keyboardType: TextInputType.number,
              maxLength: 5,
              decoration: InputDecoration(
                hintText: 'Game ID (5 digits)',
                counterText: '',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final inputText = gameIdController.text.trim();

              if (inputText.length == 5 && RegExp(r'^\d{5}$').hasMatch(inputText)) {
                final client = Provider.of<KniffelServiceClient>(context, listen: false);
                final gameState = Provider.of<KniffelGameState>(context, listen: false);

                client.joinGame(inputText, playerNameController.text.trim()).then((_) {
                  gameState.setGameId(inputText);
                  gameState.addLocalOnlinePlayer(Player(inputText));
                  Navigator.of(context).pop();
                  context.go('/wait_for_players');
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error joining game: $error')),
                  );
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please enter exactly 5 digits.')),
                );
              }
            },
            child: Text('Join Game'),
          ),
        ],
      );
    },
  );
}
