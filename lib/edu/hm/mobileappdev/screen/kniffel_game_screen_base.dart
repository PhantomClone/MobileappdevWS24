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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background/dice_background.jpg'), // Hintergrundbild
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken), // Bild abdunkeln
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_rounded, // Zurück-Pfeil-Icon
                      color: Colors.amber[100],
                      size: 40,
                    ),
                    onPressed: () {
                      final gameState = Provider.of<KniffelGameState>(context, listen: false);

                      // Navigiere je nach Modus
                      if (gameState.gameId == null) {
                        // Im Offline-Modus, wenn kein gameId existiert
                        context.go('/localGameSetup');
                      } else {
                        // Im Online-Modus, wenn gameId existiert
                        context.go('/wait_for_players');
                      }
                    },
                    splashColor: Colors.transparent, // Verhindert den Farbüberlauf bei Klick
                  ),

                  Expanded( // Verhindert, dass der Abstand zu groß wird
                    child: Text(
                      getTitle(),
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[100], // Amber Farbe für den Titel
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
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Card für Spieler Info, Neuversuche, Würfel und Neu-Werfen Button
              Card(
                elevation: 10,
                color: Color.fromRGBO(70, 70, 70, 0.8), // Durchscheinendes Grau
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 16.0, 10.0, 16.0),
                  child: Column(
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.amber[100],
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
                      const SizedBox(height: 5),
                      Text(
                        'Noch ${diceRoll.rerollsLeft} mal neu würfeln möglich:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: diceRoll.rerollsLeft > 0 ? Colors.white : Colors.transparent,
                        ),
                      ),
                      const SizedBox(height: 16),
                      buildDiceRow(),
                      const SizedBox(height: 16),
                      buildRerollButton(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              buildKniffelFields(currentPlayer, gameState),
              const SizedBox(height: 16),
              buildSetDiceToFieldButton(context, gameState),
              //const SizedBox(height: 10)
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton buildSetDiceToFieldButton(BuildContext context, KniffelGameState gameState) {
    return ElevatedButton(
      onPressed: selectedField != null ? () => submitScore(context) : null,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: selectedField == null
            ? Colors.amber[100]
            : selectedField!.getSum(diceRoll) == 0
            ? Color(0xFFB71C1C)
            : Color(0xFF388E3C),
      ),
      child: Text(
        _textForSelectedFieldButton(gameState),
        textAlign: TextAlign.center,
        style: TextStyle(
            color: selectedField == null ? Colors.white : Color(0xFF212121),
            fontSize: 18),
      ),
    );
  }

  String _textForSelectedFieldButton(KniffelGameState gameState) {
    if (selectedField == null) {
      return 'Wähle ein Feld, um die Würfel zu setzen';
    }

    if (gameState.currentPlayer.scoreCard[selectedField] != null) {
      return 'Das Feld ist schon belegt.';
    }

    final fieldSum = selectedField!.getSum(diceRoll);
    if (fieldSum == 0) {
      return 'Streiche das Feld "${selectedField!.name}"';
    }

    return 'Eintragen bei "${selectedField!.name}" (+$fieldSum Punkte)';
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
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: diceRoll.rerollsLeft > 0 && selectedDice.isNotEmpty
              ? Colors.amber[100]
              : Colors.grey
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
              : (selectedDice.isEmpty ? Colors.white : Colors.grey[900]),
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
