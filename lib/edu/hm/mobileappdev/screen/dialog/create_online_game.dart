import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/model/player.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/repository/player_repository.dart';
import 'package:provider/provider.dart';

import '../../online/client.dart';
import '../../state/play_state.dart';

createGameDialog(BuildContext context) {
  final playerRepository = Provider.of<PlayerRepository>(context, listen: false);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final playerNameController = TextEditingController();

      return AlertDialog(
        backgroundColor: Colors.grey[900],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Kniffel Online',
              style: TextStyle(
                color: Colors.amber[100],
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: playerNameController,
              keyboardType: TextInputType.text,
              maxLength: 15,
              decoration: InputDecoration(
                hintText: 'Gib deinen Namen ein',
                hintStyle: TextStyle(color: Colors.white54, fontSize: 20),
                counterText: '',
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF212121)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFFECB3)),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Abbrechen',
              style: TextStyle(color: Colors.amber[100], fontSize: 18),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final client = Provider.of<KniffelServiceClient>(context, listen: false);
              final gameState = Provider.of<KniffelGameState>(context, listen: false);
              final inputText = playerNameController.text.trim();

              if (inputText.length >= 3 && inputText.length <= 15) {
                playerRepository.addPlayer(inputText).then((_) {
                  client.createGame(inputText).then((gameId) {
                    gameState.resetPlayers(List.empty());
                    gameState.setGameId(gameId.id);
                    gameState.addLocalOnlinePlayer(Player(inputText));

                    context.go('/wait_for_players');
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error creating game: $error')),
                    );
                  });
                });
              } else {
                // Zeige eine Snackbar an, wenn der Name ungültig ist
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Der Name muss zwischen 3 und 15 Zeichen lang sein.'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: Colors.amber[100],
            ),
            child: Text(
              'Spiel erstellen',
              style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ],
      );
    },
  );
}
