import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/repository/player_repository.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/repository/player.dart';

class ScoreboardScreen extends StatefulWidget {
  const ScoreboardScreen({super.key});

  @override
  _ScoreboardScreenState createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen> {
  late Future<List<PlayerDTO>> _playersFuture;

  @override
  void initState() {
    super.initState();
    _playersFuture = Provider.of<PlayerRepository>(context, listen: false)
        .getPlayersRanking(limit: 10);
  }

  Color? _getRankColor(int index) {
    if (index == 0) {
      return Colors.amber;
    } else if (index == 1) {
      return Colors.grey;
    } else if (index == 2) {
      return Colors.deepOrangeAccent;
    } else {
      return Colors.grey[900];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background/dice_background.jpg'),
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
              const SizedBox(height: 40),
              Text(
                'Hall of Fame',
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
                child: FutureBuilder<List<PlayerDTO>>(
                  future: _playersFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No players available.'));
                    }

                    final players = snapshot.data!;
                    return ListView.builder(
                      itemCount: players.length,
                      itemBuilder: (context, index) {
                        final player = players[index];

                        return Card(
                          elevation: 10,
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          color: Colors.grey[800],
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _getRankColor(index),
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(color: Color(0xFFFFF8E1), fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: Text(
                              player.name,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFF8E1)
                              ),
                            ),
                            subtitle: Text(
                              'Score: ${player.score}',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Color(0xFFFFF8E1),
                              ),
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
                    );
                  },
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => context.go('/'),
                icon: Icon(Icons.home, size: 20),
                label: const Text(
                    'Home',
                  style: const TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[100],
                  foregroundColor: Colors.grey[900],
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
