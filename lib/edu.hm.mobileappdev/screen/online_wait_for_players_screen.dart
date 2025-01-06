import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobileappdev/generated/game.pbgrpc.dart' as game;
import 'package:provider/provider.dart';
import '../model/player.dart';
import '../online/client.dart';
import '../state/play_state.dart';

class OnlineWaitForPlayersScreen extends StatefulWidget {
  const OnlineWaitForPlayersScreen({super.key});

  @override
  State<OnlineWaitForPlayersScreen> createState() =>
      _OnlineWaitForPlayersScreenState();
}

class _OnlineWaitForPlayersScreenState extends State<OnlineWaitForPlayersScreen> {

  game.GameState gameState = game.GameState(gameStarted: false);

  late StreamSubscription<game.GameState> _subscription;

  @override
  void initState() {
    final gameState = Provider.of<KniffelGameState>(context, listen: false);
    final newPlayers = gameState.localOnlinePlayers
        .where((player) => !gameState.players.any((p) => p.name == player.name))
        .map((player) => Player(player.name));
    gameState.addAllPlayers(newPlayers);
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<KniffelGameState>(context, listen: false);
    final client = Provider.of<KniffelServiceClient>(context, listen: false);

    if (gameState.gameId != null) {
      _subscription = client.listenForGameUpdates(gameState.gameId!).listen((serverState) {
        gameState.setOnlineGameState(serverState);
        setState(() {
          if (!serverState.gameStarted) {
            final newPlayers = serverState.players
                .where((player) => !gameState.players.any((p) => p.name == player.playerName))
                .map((player) => Player(player.playerName));
            gameState.addAllPlayers(newPlayers);
          } else if (!this.gameState.gameStarted) {
            gameState.setPlayers(serverState.players.map((player) => Player(player.playerName)));
            context.go('/play_online');
          }
          this.gameState = serverState;
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Game ID: ${gameState.gameId ?? 'Loading...'}'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (gameState.gameId != null) ...[
            SizedBox(height: 16),
            Text(
              'Waiting for players...',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Players:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: gameState.players.length,
                itemBuilder: (context, index) {
                  final player = gameState.players[index];
                  return ListTile(
                    title: Text(player.name),
                  );
                },
              ),
            ),
          ] else ...[
            CircularProgressIndicator(),
          ],
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: gameState.players.isNotEmpty
                ? () {
              client.startGame(gameState.gameId!);
            }
                : null,
            child: Text('Start Game'),
          ),
        ],
      ),
    );
  }
}
