import '../model/player.dart';

class KniffelGameState {
  final List<Player> _players = [];
  int _currentPlayerIndex = 0;

  List<Player> get players => List.unmodifiable(_players);

  int get currentPlayerIndex => _currentPlayerIndex;

  Player get currentPlayer => _players[_currentPlayerIndex];

  void addPlayer(Player player) {
    _players.add(player);
  }

  void resetPlayers(List<Player> players) {
    _players
        ..clear()
        ..addAll(players);
    _currentPlayerIndex = 0;
  }

  void nextTurn() {
    if (_players.isNotEmpty) {
      _currentPlayerIndex = (_currentPlayerIndex + 1) % _players.length;
    }
  }
}