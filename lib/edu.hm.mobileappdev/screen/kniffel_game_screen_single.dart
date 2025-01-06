import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/dice_roll.dart';
import '../model/kniffel_field.dart';
import '../state/play_state.dart';
import './base/kniffel_game_screen_base.dart';

class KniffelGameScreenSingle extends StatefulWidget {
  const KniffelGameScreenSingle({super.key});

  @override
  State<KniffelGameScreenSingle> createState() =>
      _KniffelGameScreenSingleState();
}

class _KniffelGameScreenSingleState
    extends KniffelGameScreenBase<KniffelGameScreenSingle> {

  @override
  void initState() {
    diceRoll = DiceRoll();
    super.initState();
  }

  @override
  void rerollSelectedDice() {
    setState(() {
      diceRoll.reroll(selectedDice.toList());
      selectedDice.clear();
    });
  }

  @override
  void checkGameOver(BuildContext context) {
    final gameState = Provider.of<KniffelGameState>(context, listen: false);
    final isGameOver = gameState.players.every((player) =>
        KniffelField.values.every((field) => player.scoreCard[field] != null));
    if (isGameOver) {
      Navigator.pushNamed(context, '/result');
    }
  }

  @override
  void submitScore(BuildContext context) {
    if (selectedField != null) {
      final gameState = Provider.of<KniffelGameState>(context, listen: false);
      final currentPlayer = gameState.currentPlayer;
      final success = currentPlayer.setScore(selectedField!, diceRoll);
      if (success) {
        setState(() {
          selectedDice.clear();
          selectedField = null;
          diceRoll = DiceRoll();
          gameState.nextTurn();
        });
        checkGameOver(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Field already filled!')),
        );
      }
    }
  }

  @override
  String getTitle() {
    return 'Kniffel Game - Singleplayer';
  }

}
