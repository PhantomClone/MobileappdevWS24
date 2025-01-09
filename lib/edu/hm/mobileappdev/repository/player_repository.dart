import 'package:mobileappdev/edu/hm/mobileappdev/repository/player.dart';

abstract class PlayerRepository {
  Future<String> addPlayer(String id);
  Future<void> addPlayerScore(String id, int score);
  Future<List<PlayerDTO>> getPlayersRanking({int limit});
}