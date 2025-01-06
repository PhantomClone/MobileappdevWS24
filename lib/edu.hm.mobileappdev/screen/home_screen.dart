import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobileappdev/edu.hm.mobileappdev/state/play_state.dart';
import 'package:mobileappdev/edu.hm.mobileappdev/model/player.dart';
import 'package:go_router/go_router.dart';
import '../online/client.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<TextEditingController> _playerControllers = [TextEditingController()];
  final TextEditingController _onlinePlayerController = TextEditingController();
  String? _errorMessage;
  String? _selectedMode; // local/ online game selection

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

  void _startOnlineGame(BuildContext context) {
    final playerName = _onlinePlayerController.text.trim();
    if (playerName.isNotEmpty) {

      // TODO implement online game!!

      print('Online game started for player: $playerName');
      context.go('/play');
    } else {
      setState(() {
        _errorMessage = 'Please enter your name before starting the game.';
      });
    }
  }

  void _resetToModeSelection() {
    setState(() {
      _selectedMode = null;
      _errorMessage = null;
      for (final controller in _playerControllers) {
        controller.clear();
      }
      _onlinePlayerController.clear();
    });
  }

  @override
  void dispose() {
    for (final controller in _playerControllers) {
      controller.dispose();
    }
    _onlinePlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kniffel Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _selectedMode == null
            ? _buildModeSelection()
            : _selectedMode == 'local'
            ? _buildLocalGameSetup(context)
            : _buildOnlineGameSetup(context),
      ),
    );
  }

  Widget _buildModeSelection() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () => setState(() => _selectedMode = 'local'),
            child: const Text('Start Local Game'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => setState(() => _selectedMode = 'online'),
            child: const Text('Start Online Game'),
          ),
        ],
      ),
    );
  }

  Widget _buildLocalGameSetup(BuildContext context) {
    return Column(
      children: [
        ..._playerControllers.map(
              (controller) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Enter Player ${_playerControllers.indexOf(controller) + 1} Name',
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
              child: const Text('Start Game'),
            ),
            ElevatedButton(
              onPressed: _resetToModeSelection,
              child: const Text('Back'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOnlineGameSetup(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: _onlinePlayerController,
            decoration: const InputDecoration(
              labelText: 'Enter Your Name',
              border: OutlineInputBorder(),
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
        const Spacer(),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _startOnlineGame(context),
              child: const Text('Start Online Game'),
            ),
            ElevatedButton(
              onPressed: _resetToModeSelection,
              child: const Text('Back'),
            ),
          ],
        ),
      ],
    );
  }
}