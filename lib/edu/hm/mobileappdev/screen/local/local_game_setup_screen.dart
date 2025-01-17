import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/state/play_state.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/model/player.dart';
import 'package:go_router/go_router.dart';

import '../dialog/confim_back.dart';

class LocalGameSetupScreen extends StatefulWidget {
  const LocalGameSetupScreen({super.key});

  @override
  State<LocalGameSetupScreen> createState() => _LocalGameSetupScreenState();
}

class _LocalGameSetupScreenState extends State<LocalGameSetupScreen> {
  final List<TextEditingController> _playerControllers = [TextEditingController()];
  final List<FocusNode> _focusNodes = [FocusNode()];
  String? _errorMessage;

  void _addPlayerField() {
    if (_playerControllers.every((controller) => controller.text.isNotEmpty) && _playerControllers.length < 4) {
      setState(() {
        _playerControllers.add(TextEditingController());
        _focusNodes.add(FocusNode());
        _errorMessage = null;
      });
      FocusScope.of(context).requestFocus(_focusNodes.last);
    } else {
      setState(() {
        _errorMessage = 'Bitte gib zuerst alle anderen Namen ein.';
      });
    }
  }

  void _removePlayerField(int index) {
    setState(() {
      _playerControllers.removeAt(index);
      _focusNodes.removeAt(index);
    });
  }

  void _startLocalGame(BuildContext context) {
    final players = _playerControllers
        .where((controller) => controller.text.isNotEmpty)
        .map((controller) => Player(controller.text))
        .toList();

    if (players.isEmpty) {
      setState(() {
        _errorMessage = '';
      });
    } else {
      final gameState = Provider.of<KniffelGameState>(context, listen: false);
      gameState.resetPlayers(players);
      context.go('/play');
    }
  }

  @override
  void dispose() {
    for (final controller in _playerControllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background/dice_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                'Setup Lokales Spiel',
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
              const SizedBox(height: 100),

              _buildPlayerSelection(),

              Expanded(child: Container()),
              _buildButton(
                label: 'Spiel starten',
                color: Color(0xFFFFECB3),
                textColor: Color(0xFF212121),
                onPressed: () => _startLocalGame(context),
              ),
              const SizedBox(height: 16),
              _buildButton(
                icon: Icons.arrow_back,
                label: 'Zurück',
                color: Color(0xFFFFECB3),
                onPressed: () => context.go('/'),
                textColor: Colors.grey[900],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerSelection() {
    return Center(
      child: Card(
        elevation: 10,
        color: Color.fromRGBO(70, 70, 70, 0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Gib die Namen ein:",
                style: TextStyle(fontSize: 30, color: Color(0xFFFFECB3), fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ..._playerControllers.asMap().entries.map((entry) {
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
                          focusNode: _focusNodes[index],
                          style: const TextStyle(color: Color(0xFFFFECB3), fontSize: 20),
                          decoration: InputDecoration(
                            labelText: 'Spieler #${index + 1}',
                            labelStyle: const TextStyle(color: Color(0xFFFFECB3), fontSize: 18),
                            border: const OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.grey[850],
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFECB3)),
                            ),
                          ),
                        ),
                      ),
                      if (_playerControllers.length > 1)
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red, size: 30),
                          onPressed: () => _removePlayerField(index),
                        ),
                    ],
                  ),
                );
              }),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              if (_playerControllers.length < 4)
                _buildButton(
                  label: "Zusätzlichen Spieler hinzufügen",
                  color: Color(0xFF212121),
                  onPressed: _addPlayerField,
                  textColor: Colors.white,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
    Color? textColor = Colors.white,
    IconData? icon,
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
      icon: icon != null ? Icon(icon, size: 20) : null,
      label: Text(
        label,
        style: const TextStyle(fontSize: 19),
      ),
    );
  }
}
