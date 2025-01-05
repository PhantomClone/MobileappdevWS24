class Player {
  final String id;
  final int score;

  Player({required this.id, required this.score});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      score: json['score'],
    );
  }
}
