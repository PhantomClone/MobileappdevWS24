import 'package:flutter/material.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/model/kniffel_field.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../state/play_state.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<KniffelGameState>(context, listen: false);
    final players = gameState.players;

    final scores = players.map((player) {
      //final totalScore = KniffelFieldExtension.calculateFinalScore(player.scoreCard);
      final totalScore = 42;
      return {
        'player': player.name,
        'score': totalScore
      };
    }).toList();

    scores.sort((a, b) => (b['score']! as int) - (a['score'] as int));

    return Scaffold(
      appBar: AppBar(title: Text('Results')),
      body: Column(
        children: [
          Text(
            'Game Over!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: scores.length,
              itemBuilder: (context, index) {
                final result = scores[index];
                return ListTile(
                  title: Text(
                    '${index + 1}. ${result['player']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  subtitle: Text('Score: ${result['score']} (Bonus: ${result['bonus']})'),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: Text('Home'),
              ),
              ElevatedButton(
                onPressed: () => context.go('/score'),
                child: Text('Go to Scoreboard'),
              ),
              ElevatedButton(
                onPressed: () {
                  gameState.resetPlayersToStart(players);
                  context.go('/play');
                },
                child: Text('Play Again'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
