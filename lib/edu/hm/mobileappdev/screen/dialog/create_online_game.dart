import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/model/player.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/repository/player_repository.dart';
import 'package:provider/provider.dart';

import '../../online/client.dart';
import '../../state/play_state.dart';

createGameDialog(BuildContext context) {
  final playerRepository =
      Provider.of<PlayerRepository>(context, listen: false);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final playerNameController = TextEditingController();

      return AlertDialog(
        title: Text('Enter Player Name'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Please enter player name 5 digits:'),
            TextField(
              controller: playerNameController,
              keyboardType: TextInputType.text,
              maxLength: 15,
              decoration: InputDecoration(
                hintText: 'PlayerName',
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
              final client =
                  Provider.of<KniffelServiceClient>(context, listen: false);
              final gameState =
                  Provider.of<KniffelGameState>(context, listen: false);
              final inputText = playerNameController.text.trim();
              playerRepository.addPlayer(inputText).then((_) => {
                    client.createGame(inputText).then((gameId) {
                      gameState.setGameId(gameId.id);
                      gameState.addLocalOnlinePlayer(Player(inputText));

                      context.go('/wait_for_players');
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error creating game: $error')),
                      );
                    })
                  });
            },
            child: Text('Create Game'),
          ),
        ],
      );
    },
  );
}
