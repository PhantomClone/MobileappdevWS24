import 'dart:math';

class DiceRoll {
  List<int> dice;
  int rerollsLeft;

  DiceRoll({int numberOfDice = 5, this.rerollsLeft = 2})
      : dice = List.generate(numberOfDice, (_) => _rollDie());

  static int _rollDie() => Random().nextInt(6) + 1;

  void reroll(List<int> diceToReroll) {
    if (rerollsLeft <= 0) {
      return;
    }
    for (var index in diceToReroll) {
      if (index < 0 || index >= dice.length) {
        throw ArgumentError('Invalid dice index: $index');
      }
      dice[index] = _rollDie();
    }
    rerollsLeft--;
  }

  @override
  String toString() => 'Dice: $dice, Rerolls left: $rerollsLeft';
}