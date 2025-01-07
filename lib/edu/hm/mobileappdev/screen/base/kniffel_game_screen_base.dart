import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/dice_roll.dart';
import '../../model/kniffel_field.dart';
import '../../state/play_state.dart';
import '../../widgets/kniffel_field_widget.dart';

abstract class KniffelGameScreenBase<T extends StatefulWidget>
    extends State<T> {
  late DiceRoll diceRoll;
  final Set<int> selectedDice = {};
  KniffelField? selectedField;

  void rerollSelectedDice();

  void checkGameOver(BuildContext context);

  void submitScore(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<KniffelGameState>(context);
    final currentPlayer = gameState.currentPlayer;

    return Scaffold(
      appBar: AppBar(
        title: Text(getTitle()),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Current Player: ${currentPlayer.name}',
              style: TextStyle(fontSize: 24)),
          SizedBox(height: 16),
          Text('Rerolls left: ${diceRoll.rerollsLeft}',
              style: TextStyle(fontSize: 18)),
          SizedBox(height: 16),
          Row(
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
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: diceRoll.rerollsLeft > 0 && selectedDice.isNotEmpty
                ? rerollSelectedDice
                : null,
            child: Text('Reroll Selected Dice'),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: KniffelField.values.map((field) {
                return KniffelFieldWidget(
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
          ),
          ElevatedButton(
            onPressed: selectedField != null ? () => submitScore(context) : null,
            child: Text('Submit Score'),
          ),
        ],
      ),
    );
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

  String getTitle();
}
