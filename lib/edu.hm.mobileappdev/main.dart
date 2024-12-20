import 'package:flutter/material.dart';
import 'package:mobileappdev/edu.hm.mobileappdev/state/play_state.dart';
import 'package:mobileappdev/edu.hm.mobileappdev/widgets/kniffel_game_widget.dart';

import 'model/player.dart';

void main() {
  final gameState = KniffelGameState();
  gameState.addPlayer(Player('Alice'));
  gameState.addPlayer(Player('Bob'));

  runApp(MaterialApp(
    home: KniffelGameWidget(gameState: gameState),
  ));
}