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
        _errorMessage = 'Bitte gib zuerst einen Namen ein.';
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

  void _removePlayerField(int index) {
    setState(() {
      _playerControllers.removeAt(index);
    });
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
        _errorMessage = 'Zum Starten mindestens einen Spieler eingeben!';
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
        title: const Text('Kniffel'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Spieler Eingabefelder
                    ..._playerControllers.asMap().entries.map(
                          (entry) {
                        int index = entry.key;
                        TextEditingController controller = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: controller,
                                  decoration: InputDecoration(
                                    labelText:
                                    'Spieler #${index + 1}',
                                    border: const OutlineInputBorder(),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                              if (_playerControllers.length > 1)
                                IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _removePlayerField(index),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                    // Fehlermeldung anzeigen
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    // Button zum Hinzufügen von Spielern
                    if (_playerControllers.length < 4)
                      _buildButton(
                          label: "Spieler hinzufügen",
                          color: Colors.teal,
                          onPressed: _addPlayerField),
                    const SizedBox(height: 100),
                    // Buttons für das Spielstarten und Zurück
                    _buildButton(
                      label: 'Spiel starten',
                      color: Colors.blue,
                      onPressed: () => _startLocalGame(context),
                    ),
                    const SizedBox(height: 16),
                    _buildButton(
                      label: 'Zurück',
                      color: Colors.orange,
                      onPressed: () => context.go('/'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
