import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobileappdev/edu.hm.mobileappdev/state/play_state.dart';
import 'package:mobileappdev/edu.hm.mobileappdev/model/player.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<TextEditingController> _playerControllers = [TextEditingController()];
  String? _errorMessage;

  void _addPlayerField() {
    if (_playerControllers.any((controller) => controller.text.isEmpty)) {
      setState(() {
        _errorMessage = 'Please fill out the previous field first.';
      });
      return;
    }

    if (_playerControllers.length < 4) {
      setState(() {
        _playerControllers.add(TextEditingController());
        _errorMessage = null;
      });
    }
  }

  void _startGame(BuildContext context) {
    final players = _playerControllers
        .where((controller) => controller.text.isNotEmpty)
        .map((controller) => Player(controller.text))
        .toList();

    if (players.isNotEmpty) {
      final gameState = Provider.of<KniffelGameState>(context, listen: false);
      gameState.resetPlayers(players);
      context.go('/play');
    } else {
      setState(() {
        _errorMessage = 'Please add at least one player before starting the game.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kniffel Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ..._playerControllers.map(
                  (controller) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: 'Enter Player ${_playerControllers.indexOf(controller) + 1} Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            if (_playerControllers.length < 4)
              IconButton(
                icon: Icon(Icons.add),
                onPressed: _addPlayerField,
              ),
            Spacer(),
            ElevatedButton(
              onPressed: () => _startGame(context),
              child: Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }
}