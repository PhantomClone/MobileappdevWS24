import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/state/play_state.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/model/player.dart';
import 'package:go_router/go_router.dart';

class LocalGameSetupScreen extends StatefulWidget {
  const LocalGameSetupScreen({super.key});

  @override
  State<LocalGameSetupScreen> createState() => _LocalGameSetupScreenState();
}

class _LocalGameSetupScreenState extends State<LocalGameSetupScreen> {
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

  void _startLocalGame(BuildContext context) {
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
  void dispose() {
    for (final controller in _playerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gebe Spieler namen ein'),
        backgroundColor: Colors.teal,
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
                    labelText: 'Name #${_playerControllers.indexOf(controller) + 1}',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            if (_playerControllers.length < 4)
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _addPlayerField,
              ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _startLocalGame(context),
                  child: const Text('Spiel starten'),
                ),
                ElevatedButton(
                  onPressed: () => context.go('/'),
                  child: const Text('Zurück'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
