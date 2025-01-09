import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/screen/dialog/create_online_game.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/screen/dialog/join_online_game.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kniffel'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildModeSelection(),
      ),
    );
  }

  Widget _buildModeSelection() {
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
              _buildButton(
                icon: Icons.videogame_asset,
                label: 'Lokales Spiel starten',
                color: Colors.teal,
                onPressed: () => context.go('/localGameSetup'),
              ),
              const SizedBox(height: 16),
              _buildButton(
                icon: Icons.group,
                label: 'Tritt einem Online Spiel bei',
                color: Colors.blue,
                onPressed: () => joinGameDialog(context),
              ),
              const SizedBox(height: 16),
              _buildButton(
                icon: Icons.add,
                label: 'Erstelle ein Online Spiel',
                color: Colors.orange,
                onPressed: () => createGameDialog(context),
              ),
            ],
          ),
        ),
      ),
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