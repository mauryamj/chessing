import '../supabase_client.dart';
import '../../database/app_database.dart';
import '../../database/daos/games_dao.dart';
import '../../cache/cache_service.dart';
import '../../cache/offline_first_repository.dart';
import '../../../features/history/models/game_summary.dart';

class GameModel {
  final String pgn;
  final String? result;
  final String mode;
  final int? botLevel;
  final int? timeControlSeconds;
  final int? playerAccuracy;
  final DateTime playedAt;
  final int playerColorIndex;
  final List<MoveSummary> moves;

  GameModel({
    required this.pgn,
    this.result,
    required this.mode,
    this.botLevel,
    this.timeControlSeconds,
    this.playerAccuracy,
    required this.playedAt,
    required this.playerColorIndex,
    required this.moves,
  });

  factory GameModel.fromDrift(Game g, List<Move> moves) {
    return GameModel(
      pgn: g.pgn,
      result: g.result,
      mode: g.mode,
      botLevel: g.botLevel,
      timeControlSeconds: g.timeControlSeconds,
      playerAccuracy: g.playerAccuracy,
      playedAt: g.playedAt,
      playerColorIndex: g.playerColorIndex,
      moves: moves
          .map((m) => MoveSummary(
                ply: m.ply,
                uci: m.uci,
                san: m.san,
                evalCentipawns: m.evalCentipawns,
                classification: m.classification,
                bestMoveUci: m.bestMoveUci,
              ))
          .toList(),
    );
  }
}

class GamesRepository with OfflineFirstRepository<GameSummary> {
  final AppDatabase _dao;
  final CacheService _cache;

  GamesRepository(this._dao, this._cache);

  @override
  String get cacheKey => 'match_history';

  @override
  CacheService get cacheService => _cache;

  @override
  Future<List<GameSummary>> fetchFromLocal() =>
      _dao.getCompletedGames(limit: 50);

  @override
  Future<List<GameSummary>> fetchFromRemote() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return [];
    final List<dynamic> data = await supabase
        .from('games')
        .select('*, moves(*)')
        .eq('user_id', userId)
        .order('played_at', ascending: false)
        .limit(50);
    return data.map<GameSummary>((g) => GameSummary.fromJson(g as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> saveToLocal(List<GameSummary> items) async {
    for (final item in items) {
      await _dao.insertFromRemote(item);
    }
  }

  // Push a single completed game to Supabase and returns its remote ID.
  Future<String> uploadGame(GameModel game) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not logged in');

    final gameRow = await supabase.from('games').insert({
      'user_id': userId,
      'pgn': game.pgn,
      'result': game.result,
      'mode': game.mode,
      'bot_level': game.botLevel,
      'time_control_seconds': game.timeControlSeconds,
      'player_accuracy': game.playerAccuracy,
      'played_at': game.playedAt.toIso8601String(),
    }).select('id').single();

    final remoteGameId = gameRow['id'] as String;

    // Upload moves
    if (game.moves.isNotEmpty) {
      await supabase.from('moves').insert(
            game.moves
                .map((m) => {
                      'game_id': remoteGameId,
                      'ply': m.ply,
                      'uci': m.uci,
                      'san': m.san,
                      'eval_centipawns': m.evalCentipawns,
                      'classification': m.classification,
                      'best_move_uci': m.bestMoveUci,
                    })
                .toList(),
          );
    }

    // Invalidate so next history access triggers a background refresh
    await _cache.invalidate(cacheKey);

    return remoteGameId;
  }
}
