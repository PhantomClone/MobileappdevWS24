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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background/dice_background.jpg'), // Dein Hintergrundbild
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Game ID als Text oben am Bildschirmrand
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Text(
                  'Deine Game-ID: ${gameState.gameId ?? 'Lade...'}',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[100],
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(3.0, 3.0),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Transform.rotate(
                angle: -0.1, // Winkel in Bogenmaß (hier leicht nach links kippen)
                child: Text(
                  'Teile sie mit deinen Freunden!',
                  style: TextStyle(
                    color: Colors.amber[100],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Inhalt, der die Spieler anzeigt oder den Ladeindikator
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: gameState.gameId != null
                      ? Card(
                    elevation: 10,
                    color: Color.fromRGBO(70, 70, 70, 0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Warten auf weitere Spieler...',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.amber[100]),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Aktuell im Spiel:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              itemCount: gameState.players.length,
                              itemBuilder: (context, index) {
                                final player = gameState.players[index];
                                return Card(
                                  color: Colors.grey[800],
                                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    leading: index == 0
                                        ? Icon(
                                      Icons.wifi,
                                      color: Colors.amber[100],
                                      size: 24,
                                    )
                                        : null,
                                    title: Text(
                                      player.name,
                                      style: TextStyle(color: Colors.amber[100], fontSize: 18),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      : const Center(child: CircularProgressIndicator()),
                ),
              ),
              SizedBox(height: 16),
              // Start-Button
              ElevatedButton(
                onPressed: gameState.players.isNotEmpty
                    ? () {
                  client.startGame(gameState.gameId!);
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[100],
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Spiel starten', style: TextStyle(fontSize: 20, color: Colors.grey[900])),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => context.go('/'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[100],
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Zurück', style: TextStyle(fontSize: 20, color: Colors.grey[900])),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
