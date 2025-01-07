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
    _playersFuture = Provider.of<PlayerRepository>(context, listen: false).getPlayersRanking(limit: 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scoreboard')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => context.go('/'),
            child: const Text('Home'),
          ),
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
                    return ListTile(
                      leading: Text('#${index + 1}'),
                      title: Text(player.name),
                      trailing: Text('Score: ${player.score}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
