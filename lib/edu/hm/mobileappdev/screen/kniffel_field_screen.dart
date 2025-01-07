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
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey.shade200,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: field.buildWidget(context, diceRoll),
      ),
    );
  }
}
