import 'dart:io';

import 'package:grpc/grpc.dart';

import '../../generated/game.pbgrpc.dart';

class KniffelServiceClient {
  ClientChannel? channel;
  KniffelGameClient? stub;

  KniffelServiceClient() {
    channel = ClientChannel(
      '10.0.2.2',
      //'192.168.178.20',
      port: 8080,
      options: ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );

    stub = KniffelGameClient(channel!);
  }

  Future<GameId> createGame(String playerName) async {
    final player = Player()..playerName = playerName;
    final gameId = await stub!.createGame(player);
    return gameId;
  }

  Future<Ack> joinGame(String gameId, String playerName) async {
    var joinRequest = JoinRequest();
    joinRequest.gameId = gameId;
    joinRequest.player = Player(playerName: playerName);

    final ack = await stub!.joinGame(joinRequest);
    return ack;
  }

  Future<Ack> startGame(String gameId) async {
    final game = GameId()..id = gameId;
    final ack = await stub!.startGame(game);
    return ack;
  }

  Future<GameState> sendMove(String gameId, String playerName, List<int> dice, int rerollsLeft) async {
    final player = Player()..playerName = playerName;
    final move = PlayerMove()
      ..player = player
      ..gameId = gameId
      ..dice.addAll(dice)
      ..rerollsLeft = rerollsLeft;

    final gameState = await stub!.sendMove(move);
    return gameState;
  }

  Stream<GameState> listenForGameUpdates(String gameId) {
    final game = GameId()..id = gameId;
    return stub!.listenForGameUpdates(game);
  }

  Future<void> close() async {
    await channel!.shutdown();
  }
}
