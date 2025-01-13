import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobileappdev/generated/game.pbgrpc.dart' as game;
import 'package:provider/provider.dart';
import '../../model/player.dart';
import '../../online/client.dart';
import '../../state/play_state.dart';

class OnlineWaitForPlayersScreen extends StatefulWidget {
  const OnlineWaitForPlayersScreen({super.key});

  @override
  State<OnlineWaitForPlayersScreen> createState() =>
      _OnlineWaitForPlayersScreenState();
}

class _OnlineWaitForPlayersScreenState extends State<OnlineWaitForPlayersScreen> {
  game.GameState gameState = game.GameState(gameStarted: false);
  StreamSubscription<game.GameState>? _subscription;

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
  Widget build(BuildContext context) {
    final gameState = Provider.of<KniffelGameState>(context, listen: false);
    final client = Provider.of<KniffelServiceClient>(context, listen: false);

    if (gameState.gameId != null) {
      _subscription = client.listenForGameUpdates(gameState.gameId!).listen((serverState) {
        if (!mounted) return;

        gameState.setOnlineGameState(serverState);
        setState(() {
          if (!serverState.gameStarted) {
            final newPlayers = serverState.players
                .where((player) => !gameState.players.any((p) => p.name == player.playerName))
                .map((player) => Player(player.playerName));
            gameState.addAllPlayers(newPlayers);
          } else if (!this.gameState.gameStarted) {
            gameState.setPlayers(serverState.players.map((player) => Player(player.playerName)));
            gameState.setCurrentPlayer(Player(serverState.currentPlayer.playerName));
            _subscription?.cancel();
            context.go('/play_online');
          }
          this.gameState = serverState;
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Game ID: ${gameState.gameId ?? 'Lade...'}'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (gameState.gameId != null) ...[
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Warten auf Spieler...',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Spieler:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        height: 200,
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
                    ],
                  ),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Spiel starten', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}