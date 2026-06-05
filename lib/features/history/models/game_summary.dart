class MoveSummary {
  final int ply;
  final String uci;
  final String san;
  final int? evalCentipawns;
  final String? classification;
  final String? bestMoveUci;

  MoveSummary({
    required this.ply,
    required this.uci,
    required this.san,
    this.evalCentipawns,
    this.classification,
    this.bestMoveUci,
  });

  factory MoveSummary.fromJson(Map<String, dynamic> json) {
    return MoveSummary(
      ply: json['ply'] as int,
      uci: json['uci'] as String,
      san: json['san'] as String,
      evalCentipawns: json['eval_centipawns'] as int?,
      classification: json['classification'] as String?,
      bestMoveUci: json['best_move_uci'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ply': ply,
      'uci': uci,
      'san': san,
      'eval_centipawns': evalCentipawns,
      'classification': classification,
      'best_move_uci': bestMoveUci,
    };
  }
}

class GameSummary {
  final String? remoteId;
  final int? localId;
  final String pgn;
  final String? result;
  final String mode;
  final int? botLevel;
  final int? timeControlSeconds;
  final int? playerAccuracy;
  final int playerColorIndex;
  final DateTime playedAt;
  final List<MoveSummary> moves;

  GameSummary({
    this.remoteId,
    this.localId,
    required this.pgn,
    this.result,
    required this.mode,
    this.botLevel,
    this.timeControlSeconds,
    this.playerAccuracy,
    required this.playerColorIndex,
    required this.playedAt,
    required this.moves,
  });

  factory GameSummary.fromJson(Map<String, dynamic> json) {
    final movesList = json['moves'] as List<dynamic>? ?? [];
    return GameSummary(
      remoteId: json['id'] as String?,
      pgn: json['pgn'] as String,
      result: json['result'] as String?,
      mode: json['mode'] as String,
      botLevel: json['bot_level'] as int?,
      timeControlSeconds: json['time_control_seconds'] as int?,
      playerAccuracy: json['player_accuracy'] as int?,
      playerColorIndex: json['player_color_index'] as int? ?? 0,
      playedAt: DateTime.parse(json['played_at'] as String),
      moves: movesList.map((m) => MoveSummary.fromJson(m as Map<String, dynamic>)).toList(),
    );
  }

  bool get isWin => result == '1-0' && playerColorIndex == 0 || result == '0-1' && playerColorIndex == 1;
  bool get isLoss => result == '0-1' && playerColorIndex == 0 || result == '1-0' && playerColorIndex == 1;
  bool get isDraw => result == '1/2-1/2';
}
