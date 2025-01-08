import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/main.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/model/player.dart';
import 'package:provider/provider.dart';
import '../model/dice_roll.dart';
import '../model/kniffel_field.dart';
import '../state/play_state.dart';
import 'kniffel_field_screen.dart';

abstract class KniffelGameScreenBase<T extends StatefulWidget>
    extends State<T> {
  late DiceRoll diceRoll;
  final Set<int> selectedDice = {};
  KniffelField? selectedField;

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
          Text(
            'Aktueller Spieler: ${currentPlayer.name}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
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
          buildKniffelFields(currentPlayer),
          buildSetDiceToFieldButton(context),
          SizedBox(height: 10)
        ],
      ),
    );
  }

  ElevatedButton buildSetDiceToFieldButton(BuildContext context) {
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
            selectedField == null
                ? 'Wähle ein Feld'
                : selectedField!.getSum(diceRoll) == 0
                    ? 'Streiche das Feld ${selectedField!.name}'
                    : 'Setze die Würfel auf ${selectedField!.name} (+${selectedField!.getSum(diceRoll)} Punkte)',
            textAlign: TextAlign.center,
          ),
        );
  }

  Expanded buildKniffelFields(Player currentPlayer) {
    return Expanded(
          child: ListView(
            children: KniffelField.values.map((field) {
              return KniffelFieldScreen(
                field: field,
                diceRoll: currentPlayer.scoreCard[field],
                onTap: () {
                  setState(() {
                    selectField(field);
                  });
                },
                isSelected: selectedField == field,
              );
            }).toList(),
          ),
        );
  }

  Row buildDiceRow() {
    return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(diceRoll.dice.length, (index) {
            final isSelected = selectedDice.contains(index);
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectDice(isSelected, index);
                });
              },
              child: Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  diceRoll.dice[index].toString(),
                  style: TextStyle(fontSize: 20, color: Colors.white),
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
                ? 'Wähle Würfel aus'
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

  void checkGameOver(BuildContext context) {
    final gameState = Provider.of<KniffelGameState>(context, listen: false);
    final isGameOver = gameState.players.every((player) =>
        KniffelField.values.every((field) => player.scoreCard[field] != null));
    if (isGameOver) {
      context.go('/result');
    }
  }

  void selectField(KniffelField field) {
    selectedField = field;
  }

  void selectDice(bool isSelected, int index) {
    if (isSelected) {
      selectedDice.remove(index);
    } else {
      selectedDice.add(index);
    }
  }

}
