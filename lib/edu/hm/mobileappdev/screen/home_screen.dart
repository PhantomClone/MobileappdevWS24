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
                'Willkommen bei Kniffel!',
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
              _buildModeSelection(),
              Expanded(
                child: Container(),
              ),
              _buildButton(
                icon: Icons.emoji_events,
                label: 'Zur Rangliste',
                color: Color(0xFFFFECB3),
                onPressed: () => context.go('/score'),
                textColor: Colors.grey[900],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeSelection() {
    return Center(
      child: Card(
        elevation: 10,
        color: Color.fromRGBO(70, 70, 70, 0.8),
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
                "Wähle den Spielmodus:",
                style: const TextStyle(fontSize: 30, color: Color(0xFFFFECB3), fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildButton(
                icon: Icons.videogame_asset,
                label: 'Lokales Spiel starten',
                color: Color(0xFF212121),
                onPressed: () => context.go('/localGameSetup'),
              ),
              const SizedBox(height: 16),
              _buildButton(
                icon: Icons.group,
                label: 'Tritt einem Online Spiel bei',
                color: Color(0xFF212121),
                onPressed: () => joinGameDialog(context),
              ),
              const SizedBox(height: 16),
              _buildButton(
                icon: Icons.add,
                label: 'Erstelle ein Online Spiel',
                color: Color(0xFF212121),
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
