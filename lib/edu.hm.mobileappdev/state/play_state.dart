import 'package:mobileappdev/generated/game.pb.dart'as game;

import '../model/player.dart';

class KniffelGameState {
  final List<Player> _players = [];
  int _currentPlayerIndex = 0;
  //Online
  String? _gameId;
  game.GameState _gameState = game.GameState(gameStarted: false);
  final List<Player> _localOnlinePlayers = [];

  List<Player> get players => List.unmodifiable(_players);

  int get currentPlayerIndex => _currentPlayerIndex;

  Player get currentPlayer => _players[_currentPlayerIndex];

  String? get gameId => _gameId;
  game.GameState get currentOnlineGameState => _gameState;

  List<Player> get localOnlinePlayers => List.unmodifiable(_players);

  void addLocalOnlinePlayer(Player player) {
    _localOnlinePlayers.add(player);
  }

  void setOnlineGameState(game.GameState gameState) {
    _gameState = gameState;
  }

  void setGameId(String gameId) {
    _gameId = gameId;
  }

  void addPlayer(Player player) {
    _players.add(player);
  }

  void resetPlayers(List<Player> players) {
    _players
        ..clear()
        ..addAll(players);
    _currentPlayerIndex = 0;
    _localOnlinePlayers.clear();
  }

  void nextTurn() {
    if (_players.isNotEmpty) {
      _currentPlayerIndex = (_currentPlayerIndex + 1) % _players.length;
    }
  }

  void resetPlayersToStart(List<Player> players) {
    for (var player in players) {
      player.scoreCard.clear();
    }
    _gameId = null;
  }

  void addAllPlayers(Iterable<Player> newPlayers) {
    _players.addAll(newPlayers);
  }

  void setPlayers(Iterable<Player> players) {
    _players.clear();
    _players.addAll(players);
  }
}