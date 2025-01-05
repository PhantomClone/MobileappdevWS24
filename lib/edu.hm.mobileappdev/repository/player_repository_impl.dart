import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobileappdev/edu.hm.mobileappdev/repository/player.dart';
import 'package:mobileappdev/edu.hm.mobileappdev/repository/player_repository.dart';

//TODO anpassen für unseres

class PlayerRepositoryImplementation implements PlayerRepository {
  final String apiUrl = 'http://10.28.252.23:30080';

  @override
  Future<void> addPlayer(String id) async {
    final uri = Uri.parse('$apiUrl/api/players');
    final Map<String, String> body = {'id': id};
    final response = await http.post(uri, body: jsonEncode(body));

    if (response.statusCode != 200) {
      throw Exception(
          'Error while trying to add new player: ${response.body}'
      );
    }
  }

  @override
  Future<void> addPlayerWin(String id) async {
    final uri = Uri.parse('$apiUrl/api/players/$id/score/win');
    final response = await http.post(uri);

    if (response.statusCode != 200) {
      throw Exception(
          'Error while trying to add win to player: ${response.body}'
      );
    }
  }

  @override
  Future<Player> getPlayer(String id) async {
    final uri = Uri.parse('$apiUrl/api/players/$id');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> player = jsonDecode(response.body);
      return Player.fromJson(player);
    }
    else {
      throw Exception(
          'Error while trying to get player: ${response.body}'
      );
    }
  }

  @override
  Future<List<Player>> getPlayersList() async {
    final uri = Uri.parse('$apiUrl/api/players');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      List<Player> players = data.map((data) => Player.fromJson(data)).toList();
      players.sort((a, b) => b.score.compareTo(a.score));
      return players;
    }
    else {
      throw Exception(
          'Error while trying to get all players: ${response.body}'
      );
    }
  }
}