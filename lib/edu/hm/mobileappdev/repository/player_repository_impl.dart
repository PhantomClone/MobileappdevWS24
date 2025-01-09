import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobileappdev/edu/hm/mobileappdev/repository/player.dart';
import 'package:mobileappdev/edu/hm/mobileappdev/repository/player_repository.dart';

class PlayerRepositoryImplementation implements PlayerRepository {
  final String apiUrl = 'http://10.28.252.23:30080';

  @override
  Future<String> addPlayer(String name) async {
    final uri = Uri.parse('$apiUrl/players/create');
    final Map<String, String> body = {'name': name};
    final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body)
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['id'];
    } else {
      throw Exception(
          'Error while trying to add new player: ${response.body}');
    }
  }
  
  @override
  Future<void> addPlayerScore(String id, int score) async {
    final uri = Uri.parse('$apiUrl/players/$id/score');
    final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'score': score})
    );

    if (response.statusCode != 204) {
      throw Exception(
          'Error while trying to set score for player: ${response.body}');
    }
  }

  Future<List<PlayerDTO>> getPlayersRanking({int limit = 10}) async {
    final uri = Uri.parse('$apiUrl/players/ranking?limit=$limit');
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => PlayerDTO.fromJson(e)).toList();
    } else {
      throw Exception(
          'Error while trying to get players ranking: ${response.body}');
    }
  }
}