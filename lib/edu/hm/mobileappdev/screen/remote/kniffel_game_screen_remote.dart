import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/model/dice_roll.dart';
import 'package:provider/provider.dart';
import '../../../../../generated/game.pb.dart' as game;
import '../../../../../generated/game.pbenum.dart' as gamee;
import '../../model/kniffel_field.dart';
import '../../model/player.dart';
import '../../online/client.dart';
import '../kniffel_game_screen_base.dart';
import '../../state/play_state.dart';

class KniffelGameScreenRemote extends StatefulWidget {
  const KniffelGameScreenRemote({super.key});

  @override
  State<KniffelGameScreenRemote> createState() =>
      _KniffelGameScreenRemoteState();
}

class _KniffelGameScreenRemoteState
    extends KniffelGameScreenBase<KniffelGameScreenRemote> {
  late StreamSubscription<game.GameState> _subscription;

  @override
  void initState() {
    final gameState = Provider.of<KniffelGameState>(context, listen: false);
    final client = Provider.of<KniffelServiceClient>(context, listen: false);
    diceRoll = DiceRoll();

    _subscription =
        client.listenForGameUpdates(gameState.gameId!).listen((serverState) {
      gameState.setOnlineGameState(serverState);
      gameState.setCurrentPlayer(Player(serverState.currentPlayer.playerName));
      game.PlayerMove playerMove = serverState.moves.last;

      Player player = gameState.players
          .firstWhere((player) => player.name == playerMove.player.playerName);

      setState(() {
        diceRoll = DiceRoll();
        diceRoll.rerollsLeft = playerMove.rerollsLeft;
        diceRoll.dice = List.of(playerMove.dice);
        if (playerMove.done != game.KniffelField.none) {
          markForNewPlayer();
          player.scoreCard[mapKniffelField(playerMove.done)] = diceRoll;
        }
        print("Update UI");
        print(diceRoll);
      });
      if (playerMove.done != game.KniffelField.none &&
          _isAllowedToInteract(gameState)) {
        Future.delayed(Duration(seconds: 3), () {
          var diceRoll = DiceRoll();
          client.sendMove(
              gameState.gameId!,
              serverState.currentPlayer.playerName,
              diceRoll.dice,
              diceRoll.rerollsLeft,
              game.KniffelField.none);
        });
        return;
      }
    });
    super.initState();
  }

  @override
  void checkGameOver(BuildContext context) {
    final gameState = Provider.of<KniffelGameState>(context, listen: false);
    final isGameOver = gameState.players.every((player) =>
        KniffelField.values.every((field) => player.scoreCard[field] != null));
    if (isGameOver) {
      _subscription.cancel();
      context.go('/result');
    }
  }

  @override
  void selectDice(bool isSelected, int index) {
    final gameState = Provider.of<KniffelGameState>(context, listen: false);
    if (_isAllowedToInteract(gameState)) {
      super.selectDice(isSelected, index);
    }
  }

  @override
  void selectField(KniffelField field, KniffelGameState gameState) {
    if (_isAllowedToInteract(gameState)) {
      super.selectField(field, gameState);
    }
  }

  @override
  void rerollSelectedDice() {
    markForNewPlayer();
    final gameState = Provider.of<KniffelGameState>(context, listen: false);
    if (_isAllowedToInteract(gameState)) {
      final client = Provider.of<KniffelServiceClient>(context, listen: false);
      diceRoll.reroll(selectedDice.toList());
      client.sendMove(gameState.gameId!, gameState.currentPlayer.name,
          diceRoll.dice, diceRoll.rerollsLeft, game.KniffelField.none);
      selectedDice.clear();
    }
  }

  @override
  void submitScore(BuildContext context) {
    if (selectedField != null) {
      final gameState = Provider.of<KniffelGameState>(context, listen: false);
      final currentPlayer = gameState.currentPlayer;
      final success = currentPlayer.setScore(selectedField!, diceRoll);
      if (success) {
        markForNewPlayer();
        final client =
            Provider.of<KniffelServiceClient>(context, listen: false);

        client.sendMove(gameState.gameId!, currentPlayer.name, diceRoll.dice,
            diceRoll.rerollsLeft, mapKniffelFieldB(selectedField!));
        selectedDice.clear();
        selectedField = null;
        checkGameOver(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Field already filled!')),
        );
      }
    }
  }

  @override
  String getTitle() {
    return 'Kniffel - Online';
  }

  bool _isAllowedToInteract(KniffelGameState gameState) {
    return gameState.localOnlinePlayers.map((player) => player.name).any(
        (playerName) =>
            gameState.currentOnlineGameState.currentPlayer.playerName ==
            playerName);
  }

  game.KniffelField mapKniffelFieldB(KniffelField field) {
    switch (field) {
      case KniffelField.ones:
        return game.KniffelField.ones;
      case KniffelField.twos:
        return game.KniffelField.twos;
      case KniffelField.threes:
        return game.KniffelField.threes;
      case KniffelField.fours:
        return game.KniffelField.fours;
      case KniffelField.fives:
        return game.KniffelField.fives;
      case KniffelField.sixes:
        return game.KniffelField.sixes;
      case KniffelField.threeOfAKind:
        return game.KniffelField.threeOfAKind;
      case KniffelField.fourOfAKind:
        return game.KniffelField.fourOfAKind;
      case KniffelField.fullHouse:
        return game.KniffelField.fullHouse;
      case KniffelField.smallStraight:
        return game.KniffelField.smallStraight;
      case KniffelField.largeStraight:
        return game.KniffelField.largeStraight;
      case KniffelField.kniffel:
        return game.KniffelField.kniffel;
      case KniffelField.chance:
        return game.KniffelField.chance;
    }
  }

  KniffelField mapKniffelField(game.KniffelField field) {
    switch (field) {
      case game.KniffelField.chance:
        return KniffelField.chance;
      case gamee.KniffelField.fives:
        return KniffelField.fives;
      case gamee.KniffelField.fourOfAKind:
        return KniffelField.fourOfAKind;
      case gamee.KniffelField.fours:
        return KniffelField.fours;
      case gamee.KniffelField.fullHouse:
        return KniffelField.fullHouse;
      case gamee.KniffelField.kniffel:
        return KniffelField.kniffel;
      case gamee.KniffelField.largeStraight:
        return KniffelField.largeStraight;
      case gamee.KniffelField.none:
        return KniffelField.fives;
      case gamee.KniffelField.ones:
        return KniffelField.ones;
      case gamee.KniffelField.sixes:
        return KniffelField.sixes;
      case gamee.KniffelField.smallStraight:
        return KniffelField.smallStraight;
      case gamee.KniffelField.threeOfAKind:
        return KniffelField.threeOfAKind;
      case gamee.KniffelField.threes:
        return KniffelField.threes;
      case gamee.KniffelField.twos:
        return KniffelField.twos;
    }

    return KniffelField.fives;
  }
}
