import 'package:mobileappdev/edu.hm.mobileappdev/repository/player.dart';

abstract class PlayerRepository {
  Future<void> addPlayer(String id);
  Future<Player> getPlayer(String id);
  Future<void> addPlayerWin(String id);
  Future<List<Player>> getPlayersList();
}