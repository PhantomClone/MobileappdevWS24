import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/model/player.dart';
import 'package:provider/provider.dart';

import '../../online/client.dart';
import '../../repository/player_repository.dart';
import '../../state/play_state.dart';

joinGameDialog(BuildContext context) {
  final playerRepository = Provider.of<PlayerRepository>(context, listen: false);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final playerNameController = TextEditingController();
      final gameIdController = TextEditingController();

      return AlertDialog(
        backgroundColor: Colors.grey[900],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Kniffel Online ',
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
                hintText: 'Gib deinen Spielernamen ein',
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
            const SizedBox(height: 16),
            // Titel für die Game-ID
            Text(
              'Game-ID des Hosts:',
              style: TextStyle(
                color: Colors.amber[100],
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Textfeld für die Game-ID
            TextField(
              controller: gameIdController,
              keyboardType: TextInputType.number,
              maxLength: 5,
              decoration: InputDecoration(
                hintText: '5-stellige Zahlenfolge',
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
              style: TextStyle(color: Colors.amber[100], fontSize: 17),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final gameIdInput = gameIdController.text.trim();
              final playerName = playerNameController.text.trim();

              // Überprüfe, ob der Name zwischen 3 und 15 Zeichen liegt
              if (playerName.length >= 3 && playerName.length <= 15) {
                if (gameIdInput.length == 5 && RegExp(r'^\d{5}$').hasMatch(gameIdInput)) {
                  final client = Provider.of<KniffelServiceClient>(context, listen: false);
                  final gameState = Provider.of<KniffelGameState>(context, listen: false);

                  playerRepository.addPlayer(playerName).then((_) => {
                    client
                        .joinGame(gameIdInput, playerName)
                        .then((_) {
                      gameState.resetPlayers(List.empty());
                      gameState.setGameId(gameIdInput);
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
                    SnackBar(content: Text('Bitte gib genau 5 Zahlen ein.')),
                  );
                }
              } else {
                // Wenn der Name nicht zwischen 3 und 15 Zeichen ist
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Der Name muss zwischen 3 und 15 Zeichen lang sein.')),
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
              'Spiel beitreten',
              style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ],
      );
    },
  );
}
