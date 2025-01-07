import 'dice_roll.dart';
import 'kniffel_field.dart';

class Player {
  final String name;
  final Map<KniffelField, DiceRoll?> scoreCard;

  Player(this.name) : scoreCard = {
    for (var field in KniffelField.values) field: null,
  };

  bool setScore(KniffelField field, DiceRoll roll) {
    if (scoreCard[field] != null) {
      return false;
    }

    scoreCard[field] = roll;
    return true;
  }
}