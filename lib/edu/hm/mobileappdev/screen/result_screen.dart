import 'package:flutter/material.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/model/kniffel_field.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../model/dice_roll.dart';
import '../model/player.dart';
import '../repository/player_repository_impl.dart';
import '../state/play_state.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {

  Future<void> _savePlayerScore(Player player, int totalScore, {int retries = 5}) async {
    final playerRepository = PlayerRepositoryImplementation();

    try {
      final playerId = await playerRepository.addPlayer(player.name);

      await playerRepository.addPlayerScore(playerId, totalScore);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Player score erfolgreich gespeichert")),
        );
      }
    } catch (e) {
      if (retries > 0) {

        await Future.delayed(Duration(seconds: 2));

        await _savePlayerScore(player, totalScore, retries: retries - 1);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Player score nicht gespeichert :(")),
          );
        }
      }
    }
  }

  int calculatePlayerScore(Map<KniffelField, DiceRoll?> scoreCard) {
    int sumUpperFields = 0;
    int totalScore = 0;

    for (var field in KniffelFieldExtension.upperSectionFields) {
      final roll = scoreCard[field];
      final fieldScore = roll != null ? field.getSum(roll) : 0;
      sumUpperFields += fieldScore;
      totalScore += fieldScore;
    }

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

  int calculatePlayerScoreBonus(Map<KniffelField, DiceRoll?> scoreCard) {
    int sumUpperFields = 0;
    for (var field in KniffelFieldExtension.upperSectionFields) {
      final roll = scoreCard[field];
      final fieldScore = roll != null ? field.getSum(roll) : 0;
      sumUpperFields += fieldScore;
    }

    return sumUpperFields >= 63 ? 35 : 0;
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<KniffelGameState>(context, listen: false);
    final players = gameState.players;

    final scores = players.map((player) {
      final totalScore = calculatePlayerScore(player.scoreCard);
      final bonus = calculatePlayerScoreBonus(player.scoreCard);
      _savePlayerScore(player, totalScore + bonus);
      return {
        'player': player.name,
        'score': totalScore,
        'bonus': bonus
      };
    }).toList();

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
                  final bonusAchieved = result['bonus'] != 0;

                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        '${result['player']}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Punkte: ${result['score']}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Bonus: ${bonusAchieved ? '✔ Erhalten' : '✘ Nicht erreicht'}',
                            style: TextStyle(
                              fontSize: 16,
                              color: bonusAchieved ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
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
