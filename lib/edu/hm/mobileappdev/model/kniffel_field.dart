import 'package:flutter/material.dart';
import 'dice_roll.dart';

enum KniffelField {
  ones,
  twos,
  threes,
  fours,
  fives,
  sixes,
  threeOfAKind,
  fourOfAKind,
  fullHouse,
  smallStraight,
  largeStraight,
  kniffel,
  chance,
}

extension KniffelFieldExtension on KniffelField {
  static List<KniffelField> get upperSectionFields => [
    KniffelField.ones,
    KniffelField.twos,
    KniffelField.threes,
    KniffelField.fours,
    KniffelField.fives,
    KniffelField.sixes,
  ];

  String get name {
    switch (this) {
      case KniffelField.ones:
        return 'Einsen';
      case KniffelField.twos:
        return 'Zweien';
      case KniffelField.threes:
        return 'Dreien';
      case KniffelField.fours:
        return 'Vieren';
      case KniffelField.fives:
        return 'Fünfen';
      case KniffelField.sixes:
        return 'Sechsen';
      case KniffelField.threeOfAKind:
        return 'Dreierpasch';
      case KniffelField.fourOfAKind:
        return 'Viererpasch';
      case KniffelField.fullHouse:
        return 'Full House';
      case KniffelField.smallStraight:
        return 'Kleine Straße';
      case KniffelField.largeStraight:
        return 'Große Straße';
      case KniffelField.kniffel:
        return 'Kniffel';
      case KniffelField.chance:
        return 'Chance';
    }
  }

  IconData get icon {
    switch (this) {
      case KniffelField.ones:
        return Icons.looks_one;
      case KniffelField.twos:
        return Icons.looks_two;
      case KniffelField.threes:
        return Icons.looks_3;
      case KniffelField.fours:
        return Icons.looks_4;
      case KniffelField.fives:
        return Icons.looks_5;
      case KniffelField.sixes:
        return Icons.looks_6;
      case KniffelField.threeOfAKind:
        return Icons.threesixty;
      case KniffelField.fourOfAKind:
        return Icons.format_bold;
      case KniffelField.fullHouse:
        return Icons.house;
      case KniffelField.smallStraight:
        return Icons.arrow_forward;
      case KniffelField.largeStraight:
        return Icons.arrow_forward_ios;
      case KniffelField.kniffel:
        return Icons.star;
      case KniffelField.chance:
        return Icons.casino;
    }
  }

  int getSum(DiceRoll roll) {
    switch (this) {
      case KniffelField.ones:
        return roll.dice
            .where((die) => die == 1)
            .fold(0, (prev, element) => prev + element);
      case KniffelField.twos:
        return roll.dice
            .where((die) => die == 2)
            .fold(0, (prev, element) => prev + element);
      case KniffelField.threes:
        return roll.dice
            .where((die) => die == 3)
            .fold(0, (prev, element) => prev + element);
      case KniffelField.fours:
        return roll.dice
            .where((die) => die == 4)
            .fold(0, (prev, element) => prev + element);
      case KniffelField.fives:
        return roll.dice
            .where((die) => die == 5)
            .fold(0, (prev, element) => prev + element);
      case KniffelField.sixes:
        return roll.dice
            .where((die) => die == 6)
            .fold(0, (prev, element) => prev + element);
      case KniffelField.threeOfAKind:
        return _sumForCombination(3, roll);
      case KniffelField.fourOfAKind:
        return _sumForCombination(4, roll);
      case KniffelField.fullHouse:
        return _sumForFullHouse(roll);
      case KniffelField.smallStraight:
        return _sumForSmallStraight(roll);
      case KniffelField.largeStraight:
        return _sumForLargeStraight(roll);
      case KniffelField.kniffel:
        return _sumForKniffel(roll);
      case KniffelField.chance:
        return roll.dice.fold(0, (prev, element) => prev + element);
      }
  }

  int _sumForCombination(int count, DiceRoll roll) {
    final frequencies = roll.dice.fold<Map<int, int>>({}, (map, die) {
      map[die] = (map[die] ?? 0) + 1;
      return map;
    });

    final validDice = frequencies.entries
        .where((entry) => entry.value >= count)
        .expand((entry) => List.generate(entry.value, (_) => entry.key))
        .toList();

    return validDice.fold(0, (prev, element) => prev + element);
  }

  int _sumForFullHouse(DiceRoll roll) {
    final frequencies = roll.dice.fold<Map<int, int>>({}, (map, die) {
      map[die] = (map[die] ?? 0) + 1;
      return map;
    });

    if (frequencies.containsValue(3) && frequencies.containsValue(2)) {
      return 25;
    }

    return 0;
  }

  int _sumForSmallStraight(DiceRoll roll) {
    final distinctDice = roll.dice.toSet();
    if (distinctDice.containsAll([1, 2, 3, 4]) ||
        distinctDice.containsAll([2, 3, 4, 5]) ||
        distinctDice.containsAll([3, 4, 5, 6])) {
      return 30;
    }
    return 0;
  }

  int _sumForLargeStraight(DiceRoll roll) {
    final distinctDice = roll.dice.toSet();
    if (distinctDice.containsAll([1, 2, 3, 4, 5]) ||
        distinctDice.containsAll([2, 3, 4, 5, 6])) {
      return 40;
    }
    return 0;
  }

  int _sumForKniffel(DiceRoll roll) {
    final frequencies = roll.dice.fold<Map<int, int>>({}, (map, die) {
      map[die] = (map[die] ?? 0) + 1;
      return map;
    });
    if (frequencies.values.any((value) => value >= 5)) {
      return 50;
    }
    return 0;
  }

  Widget buildWidget(BuildContext context, DiceRoll? roll) {
    int sum = 0;
    if (roll != null) {
      sum = getSum(roll);
    }

    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name),
            if (roll != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dice: ${roll.dice.join(', ')}',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Sum: $sum',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    SizedBox(height: 4),
                    Wrap(
                      children: List.generate(roll.dice.length, (index) {
                        final die = roll.dice[index];
                        final isValid = _isValidDieForField(die, roll);
                        return Container(
                          margin: EdgeInsets.all(4),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isValid ? Colors.green : Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            die.toString(),
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool _isValidDieForField(int die, DiceRoll roll) {
    switch (this) {
      case KniffelField.ones:
        return die == 1;
      case KniffelField.twos:
        return die == 2;
      case KniffelField.threes:
        return die == 3;
      case KniffelField.fours:
        return die == 4;
      case KniffelField.fives:
        return die == 5;
      case KniffelField.sixes:
        return die == 6;
      case KniffelField.threeOfAKind:
        return getSum(roll) != 0;
      case KniffelField.fourOfAKind:
        return getSum(roll) != 0;
      case KniffelField.fullHouse:
        return getSum(roll) != 0;
      case KniffelField.smallStraight:
        return getSum(roll) != 0;
      case KniffelField.largeStraight:
        return getSum(roll) != 0;
      case KniffelField.kniffel:
        return getSum(roll) != 0;
      case KniffelField.chance:
        return true;
    }
  }
}
