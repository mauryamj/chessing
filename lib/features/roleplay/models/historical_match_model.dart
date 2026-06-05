class HistoricalMatchModel {
  final String id;
  final String whitePlayer;
  final String blackPlayer;
  final String event;
  final int year;
  final String result;
  final String pgn;
  final String description;
  final List<String> tags;
  final String difficulty;
  final int sortOrder;

  HistoricalMatchModel({
    required this.id,
    required this.whitePlayer,
    required this.blackPlayer,
    required this.event,
    required this.year,
    required this.result,
    required this.pgn,
    required this.description,
    required this.tags,
    required this.difficulty,
    required this.sortOrder,
  });

  factory HistoricalMatchModel.fromJson(Map<String, dynamic> json) {
    return HistoricalMatchModel(
      id: json['id'] as String,
      whitePlayer: json['white_player'] as String,
      blackPlayer: json['black_player'] as String,
      event: json['event'] as String,
      year: json['year'] as int,
      result: json['result'] as String,
      pgn: json['pgn'] as String,
      description: json['description'] as String,
      tags: List<String>.from(json['tags'] as List),
      difficulty: json['difficulty'] as String,
      sortOrder: json['sort_order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'white_player': whitePlayer,
      'black_player': blackPlayer,
      'event': event,
      'year': year,
      'result': result,
      'pgn': pgn,
      'description': description,
      'tags': tags,
      'difficulty': difficulty,
      'sort_order': sortOrder,
    };
  }
}
