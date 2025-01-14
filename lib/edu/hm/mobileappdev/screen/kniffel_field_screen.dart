import 'package:flutter/material.dart';
import '../model/dice_roll.dart';
import '../model/kniffel_field.dart';

class KniffelFieldScreen extends StatelessWidget {
  final KniffelField field;
  final DiceRoll? diceRoll;
  final VoidCallback? onTap;
  final bool isSelected;

  const KniffelFieldScreen({
    super.key,
    required this.field,
    this.diceRoll,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber.shade100 : Colors.grey.shade800,
          borderRadius: BorderRadius.circular(16), // Abgerundete Ecken
        ),
        child: field.buildWidget(context, diceRoll), // Der Inhalt bleibt unverändert
      ),
    );
  }

}
