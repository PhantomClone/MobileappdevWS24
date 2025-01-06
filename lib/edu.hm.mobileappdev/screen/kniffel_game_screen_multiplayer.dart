import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobileappdev/edu.hm.mobileappdev/model/dice_roll.dart';
import 'package:provider/provider.dart';
import '../../generated/game.pb.dart' as game;
import '../../generated/game.pbenum.dart' as gamee;
import '../model/kniffel_field.dart';
import '../model/player.dart';
import '../online/client.dart';
import './base/kniffel_game_screen_base.dart';
import '../state/play_state.dart';

class KniffelGameScreenMultiplayer extends StatefulWidget {
  const KniffelGameScreenMultiplayer({super.key});

  @override
  State<KniffelGameScreenMultiplayer> createState() =>
      _KniffelGameScreenMultiplayerState();
}

class _KniffelGameScreenMultiplayerState
    extends KniffelGameScreenBase<KniffelGameScreenMultiplayer> {
  late StreamSubscription<game.GameState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    final gameState = Provider.of<KniffelGameState>(context, listen: false);
    final client = Provider.of<KniffelServiceClient>(context, listen: false);

    _subscription = client.listenForGameUpdates(gameState.gameId!).listen((serverState) {
      setState(() {
        gameState.setOnlineGameState(serverState);
        game.PlayerMove playerMove = serverState.moves.last;

        Player player = gameState.players
            .firstWhere((player) => player.name == playerMove.player.playerName);
        diceRoll = DiceRoll();
        diceRoll.rerollsLeft = playerMove.rerollsLeft;
        diceRoll.dice = playerMove.dice;
        if (playerMove.done != game.KniffelField.none) {
          player.scoreCard[mapKniffelField(playerMove.done)] = diceRoll;
        }

        if (playerMove.done != game.KniffelField.none && _isAllowedToInteract(gameState)) {
          diceRoll = DiceRoll();
          Future.delayed(Duration(seconds: 5), () {
            client.sendMove(gameState.gameId!, serverState.currentPlayer.playerName, diceRoll.dice, diceRoll.rerollsLeft);
          });
          return;
        }

        if (_isAllowedToInteract(gameState)) {
          diceRoll = DiceRoll();
        }
      });
    });
    super.initState();
  }

  @override
  void checkGameOver(BuildContext context) {
    // TODO: implement checkGameOver
  }

  @override
  void rerollSelectedDice() {
    // TODO: implement rerollSelectedDice
  }

  @override
  void submitScore(BuildContext context) {
    // TODO: implement submitScore
  }

  @override
  String getTitle() {
    return 'Kniffel Game - Multiplayer';
  }

  bool _isAllowedToInteract(KniffelGameState gameState) {
    return gameState.localOnlinePlayers
        .map((player) => player.name)
        .any((playerName) => gameState.currentOnlineGameState.currentPlayer.playerName == playerName);
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
