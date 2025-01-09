import 'package:flutter/material.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/model/kniffel_field.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../model/dice_roll.dart';
import '../state/play_state.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {

  int calculatePlayerScore(Map<KniffelField, DiceRoll?> scoreCard) {
    int sumUpperFields = 0;
    int totalScore = 0;

    KniffelFieldExtension.upperSectionFields.forEach((field) {
      final roll = scoreCard[field];
      final fieldScore = roll != null ? field.getSum(roll) : 0;
      sumUpperFields += fieldScore;
      totalScore += fieldScore;
    });

    if (sumUpperFields >= 63) {
      totalScore += 35;
    }

    KniffelField.values.skip(6).forEach((field) {
      final roll = scoreCard[field];
      final fieldScore = roll != null ? field.getSum(roll) : 0;
      totalScore += fieldScore;
    });

    return totalScore;
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<KniffelGameState>(context, listen: false);
    final players = gameState.players;

    final scores = players.map((player) {
      final totalScore = calculatePlayerScore(player.scoreCard);
      final bonus = totalScore >= 63 ? 35 : 0; // Bonus von 35, wenn mindestens 63 Punkte in den oberen Feldern erreicht wurden
      return {
        'player': player.name,
        'score': totalScore,
        'bonus': bonus
      };
    }).toList();

    // Sortiere die Spieler nach ihrem Gesamtscore, absteigend
    scores.sort((a, b) => (b['score']! as int) - (a['score'] as int));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ergebnisse'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildResultList(scores),
      ),
    );
  }

  Widget _buildResultList(List<Map<String, dynamic>> scores) {
    return Center(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Spiel ist beendet!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: scores.length,
                  itemBuilder: (context, index) {
                    final result = scores[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text('${index + 1}', style: TextStyle(color: Colors.white)),
                        backgroundColor: Colors.teal,
                      ),
                      title: Text(
                        '${result['player']}',
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        'Punkte: ${result['score']} (Bonus: ${result['bonus']})',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildButton(
          icon: Icons.refresh,
          label: 'Noch eine Runde',
          color: Colors.teal,
          onPressed: () {
            final gameState = Provider.of<KniffelGameState>(context, listen: false);
            gameState.resetPlayersToStart(gameState.players);
            context.go('/play');
          },
        ),
        const SizedBox(height: 16),
        _buildButton(
          icon: Icons.home,
          label: 'Zurück zur Startseite',
          color: Colors.blue,
          onPressed: () => context.go('/'),
        ),
        const SizedBox(height: 16),
        _buildButton(
          icon: Icons.score,
          label: 'Zur Rangliste',
          color: Colors.orange,
          onPressed: () => context.go('/score'),
        ),
      ],
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
