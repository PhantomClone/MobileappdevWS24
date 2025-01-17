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
  void dispose() {
    final gameState = Provider.of<KniffelGameState>(context, listen: false);
    gameState.resetPlayersToStart(List.empty());
    super.dispose();
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background/dice_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                'Das Spiel ist beendet!',
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
              const SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildResultList(scores),
                ),
              ),
              _buildBottomButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultList(List<Map<String, dynamic>> scores) {
    return Center(
      child: Card(
        elevation: 4,
        color: Color.fromRGBO(70, 70, 70, 0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Platzierungen:",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.amber[100]),
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
                      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                      color: Colors.grey[900],
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: index == 0
                              ? Colors.amber
                              : index == 1
                              ? Colors.grey
                              : index == 2
                              ? Colors.deepOrangeAccent
                              : Colors.black,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(color: Color(0xFFFFF8E1), fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          '${result['player']}',
                          style: TextStyle(color: Color(0xFFFFF8E1), fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Punkte: ${result['score']}',
                              style: TextStyle(fontSize: 16, color: Color(0xFFFFF8E1), fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Bonus: ${bonusAchieved ? '✔ (+ 35 P.)' : '✘'}',
                              style: TextStyle(
                                fontSize: 16,
                                color: bonusAchieved ? Colors.green : Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        trailing: index == 0
                            ? Icon(
                          Icons.emoji_events,
                          color: Colors.amber,
                          size: 30,
                        )
                            : null,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              _buildButton(
                icon: Icons.refresh,
                label: 'Noch eine Runde',
                color: Colors.grey.shade900,
                onPressed: () {
                  final gameState = Provider.of<KniffelGameState>(context, listen: false);
                  gameState.resetPlayersToStart(gameState.players);
                  context.go('/play');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildButton(
            icon: Icons.score,
            label: 'Zur Rangliste',
            color: Colors.amber.shade100,
            textColor: Colors.grey.shade800,
            onPressed: () => context.go('/score'),
          ),
          const SizedBox(height: 16),
          _buildButton(
            icon: Icons.home,
            label: 'Zurück zur Startseite',
            color: Colors.amber.shade100,
            textColor: Colors.grey.shade800,
            onPressed: () => context.go('/'),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    Color? textColor = Colors.white,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
