import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/dice_roll.dart';
import '../model/kniffel_field.dart';
import '../state/play_state.dart';
import 'kniffel_field_widget.dart';

//TODO +35 bei Score > 63 in Einser - Sechser

class KniffelGameWidget extends StatefulWidget {

  const KniffelGameWidget({super.key,});

  @override
  State<KniffelGameWidget> createState() => _KniffelGameWidgetState();
}

class _KniffelGameWidgetState extends State<KniffelGameWidget> {
  late DiceRoll diceRoll;
  final Set<int> selectedDice = {};
  KniffelField? selectedField;

  @override
  void initState() {
    super.initState();
    diceRoll = DiceRoll();
  }

  void rerollSelectedDice() {
    setState(() {
      diceRoll.reroll(selectedDice.toList());
      selectedDice.clear();
    });
  }

  void submitScore() {
    if (selectedField != null) {
      final gameState = Provider.of<KniffelGameState>(context, listen: false); // fixed exception "Tried to listen to a value exposed with provider, from outside of the widget tree."
      final currentPlayer = gameState.currentPlayer;
      final success = currentPlayer.setScore(selectedField!, diceRoll);
      if (success) {
        setState(() {
          selectedDice.clear();
          selectedField = null;
          diceRoll = DiceRoll();
          gameState.nextTurn();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Field already filled!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<KniffelGameState>(context);
    final currentPlayer = gameState.currentPlayer;

    return Scaffold(
      appBar: AppBar(
        title: Text('Kniffel Game'),
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
                    if (isSelected) {
                      selectedDice.remove(index);
                    } else {
                      selectedDice.add(index);
                    }
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
                      selectedField = field;
                    });
                  },
                  isSelected: selectedField == field,
                );
              }).toList(),
            ),
          ),
          ElevatedButton(
            onPressed: selectedField != null ? submitScore : null,
            child: Text('Submit Score'),
          ),
        ],
      ),
    );
  }
}