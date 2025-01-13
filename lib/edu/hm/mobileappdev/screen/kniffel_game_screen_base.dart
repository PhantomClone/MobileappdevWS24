import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/model/player.dart';
import 'package:provider/provider.dart';
import '../model/dice_roll.dart';
import '../model/kniffel_field.dart';
import '../state/play_state.dart';
import 'dice_screen.dart';
import 'kniffel_field_screen.dart';

abstract class KniffelGameScreenBase<T extends StatefulWidget>
    extends State<T> {
  late DiceRoll diceRoll;
  final Set<int> selectedDice = {};
  KniffelField? selectedField;
  bool markedForNewPlayer = false;

  String getTitle();

  void rerollSelectedDice();

  void submitScore(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<KniffelGameState>(context);
    final currentPlayer = gameState.currentPlayer;

    return Scaffold(
      appBar: AppBar(
        title: Text(getTitle()),
        backgroundColor: Colors.teal,
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 24,
                color: Colors.black87,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Spieler ',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
                TextSpan(
                  text: currentPlayer.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ' ist an der Reihe',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Übrige Neuversuche: ${diceRoll.rerollsLeft}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          buildDiceRow(),
          SizedBox(height: 16),
          buildRerollButton(),
          SizedBox(height: 16),
          buildKniffelFields(currentPlayer, gameState),
          buildSetDiceToFieldButton(context, gameState),
          SizedBox(height: 10)
        ],
      ),
    );
  }

  ElevatedButton buildSetDiceToFieldButton(BuildContext context, KniffelGameState gameState) {
    return ElevatedButton(
          onPressed:
              selectedField != null ? () => submitScore(context) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedField == null
                ? Colors.grey
                : selectedField!.getSum(diceRoll) == 0
                    ? Colors.red
                    : Colors.green,
          ),
          child: Text(
            _textForSelectedFieldButton(gameState),
            textAlign: TextAlign.center,
          ),
        );
  }

  String _textForSelectedFieldButton(KniffelGameState gameState) {
    if (selectedField == null) {
      return 'Wähle ein Feld um die Würfel zu setzten';
    }

    if (gameState.currentPlayer.scoreCard[selectedField] != null) {
      return 'Das Feld ist schon belegt.';
    }

    final fieldSum = selectedField!.getSum(diceRoll);
    if (fieldSum == 0) {
      return 'Streiche das Feld "${selectedField!.name}"';
    }

    return 'Setze die Würfel auf "${selectedField!.name}" (+$fieldSum Punkte)';
  }

  Expanded buildKniffelFields(Player currentPlayer, KniffelGameState gameState) {
    return Expanded(
          child: ListView(
            children: KniffelField.values.map((field) {
              return KniffelFieldScreen(
                field: field,
                diceRoll: currentPlayer.scoreCard[field],
                onTap: () {
                  setState(() {
                    selectField(field, gameState);
                  });
                },
                isSelected: selectedField == field,
              );
            }).toList(),
          ),
        );
  }

  Row buildDiceRow() {
    bool tempMarkedForNewPlayer = markedForNewPlayer;
    if (markedForNewPlayer) {
      markedForNewPlayer = false;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(diceRoll.dice.length, (index) {
        final isSelected = selectedDice.contains(index);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectDice(isSelected, index);
              });
            },
            child: DiceScreen(
              value: diceRoll.dice[index],
              duration: Duration(milliseconds: 800),
              isSelected: isSelected,
              update: tempMarkedForNewPlayer,
              rerolls: diceRoll.rerollsLeft,
            ),
          ),
        );
      }),
    );
  }

  ElevatedButton buildRerollButton() {
    return ElevatedButton(
          onPressed: diceRoll.rerollsLeft > 0 && selectedDice.isNotEmpty
              ? rerollSelectedDice
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: diceRoll.rerollsLeft > 0 && selectedDice.isNotEmpty
                ? Colors.blue
                : diceRoll.rerollsLeft > 0
                ? Colors.grey
                : Colors.red,
          ),
          child: Text(
            diceRoll.rerollsLeft == 0
                ? 'Keine Neuversuche mehr übrig'
                : (selectedDice.isEmpty
                ? 'Wähle Würfel zum neu würfeln aus'
                : 'Neu werfen'),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: diceRoll.rerollsLeft == 0
                  ? Colors.white
                  : (selectedDice.isEmpty ? Colors.black54 : Colors.white),
            ),
            textAlign: TextAlign.center,
          ),
        );
  }

  void markForNewPlayer() {
    markedForNewPlayer = true;
  }

  void checkGameOver(BuildContext context) {
    final gameState = Provider.of<KniffelGameState>(context, listen: false);
    final isGameOver = gameState.players.every((player) =>
        KniffelField.values.every((field) => player.scoreCard[field] != null));
    if (isGameOver) {
      context.go('/result');
    }
  }

  void selectField(KniffelField field, KniffelGameState gameState) {
    if (gameState.currentPlayer.scoreCard[field] == null) {
      selectedField = field;
    }
  }

  void selectDice(bool isSelected, int index) {
    if (isSelected) {
      selectedDice.remove(index);
    } else {
      selectedDice.add(index);
    }
  }

}
