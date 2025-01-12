import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/dice_roll.dart';
import '../../model/kniffel_field.dart';
import '../../state/play_state.dart';
import '../kniffel_game_screen_base.dart';

class KniffelGameScreenLocal extends StatefulWidget {
  const KniffelGameScreenLocal({super.key});

  @override
  State<KniffelGameScreenLocal> createState() =>
      _KniffelGameScreenLocalState();
}

class _KniffelGameScreenLocalState
    extends KniffelGameScreenBase<KniffelGameScreenLocal> {

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
  void submitScore(BuildContext context) {
    if (selectedField != null) {
      final gameState = Provider.of<KniffelGameState>(context, listen: false);
      final currentPlayer = gameState.currentPlayer;
      final success = currentPlayer.setScore(selectedField!, diceRoll);
      if (success) {
        markForNewPlayer();
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
    return 'Kniffel - Offline';
  }

}
