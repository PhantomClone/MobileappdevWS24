import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/model/player.dart';
import 'package:provider/provider.dart';

import '../../online/client.dart';
import '../../repository/player_repository.dart';
import '../../state/play_state.dart';

joinGameDialog(BuildContext context) {
  final playerRepository =
      Provider.of<PlayerRepository>(context, listen: false);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final playerNameController = TextEditingController();
      final gameIdController = TextEditingController();

      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Bitte gib deinen Spieler Name ein'),
            TextField(
              controller: playerNameController,
              keyboardType: TextInputType.text,
              maxLength: 15,
              decoration: InputDecoration(
                hintText: 'Spieler Name',
                counterText: '',
              ),
            ),
            SizedBox(height: 5,),
            Text('Bitte gib denn fünf Stelligen Zahlen Code ein'),
            TextField(
              controller: gameIdController,
              keyboardType: TextInputType.number,
              maxLength: 5,
              decoration: InputDecoration(
                hintText: 'Game ID (5 zahlen)',
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
            child: Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () {
              final inputText = gameIdController.text.trim();

              if (inputText.length == 5 &&
                  RegExp(r'^\d{5}$').hasMatch(inputText)) {
                final client =
                    Provider.of<KniffelServiceClient>(context, listen: false);
                final gameState =
                    Provider.of<KniffelGameState>(context, listen: false);

                final playerName = playerNameController.text.trim();

                playerRepository.addPlayer(playerName).then((_) => {
                      client
                          .joinGame(inputText, playerName)
                          .then((_) {
                        gameState.setGameId(inputText);
                        gameState.addLocalOnlinePlayer(Player(playerName));
                        Navigator.of(context).pop();
                        context.go('/wait_for_players');
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error joining game: $error')),
                        );
                      })
                    });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Bitte gib genau 5 zahlen ein.')),
                );
              }
            },
            child: Text('Spiel beitretten'),
          ),
        ],
      );
    },
  );
}
