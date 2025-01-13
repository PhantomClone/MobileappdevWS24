class PlayerDTO {
  final int id;
  final String name;
  final int score;

  PlayerDTO({
    required this.id,
    required this.name,
    required this.score,
  });

  factory PlayerDTO.fromJson(Map<String, dynamic> json) {
    return PlayerDTO(
      id: json['id'],
      name: json['player']['name'],
      score: json['value'],
    );
  }
}
