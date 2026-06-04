import '../../database/app_database.dart';
import '../supabase_client.dart';

class GamesRepository {
  Future<String> uploadGame(Game game, List<Move> moves) async {
    final gameRow = await supabase.from('games').insert({
      'user_id': supabase.auth.currentUser!.id,
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
    if (moves.isNotEmpty) {
      await supabase.from('moves').insert(
        moves.map((m) => {
          'game_id': remoteGameId,
          'ply': m.ply,
          'uci': m.uci,
          'san': m.san,
          'eval_centipawns': m.evalCentipawns,
          'classification': m.classification,
        }).toList(),
      );
    }
    return remoteGameId;
  }

  Future<List<Map<String, dynamic>>> fetchGames({int limit = 20, int offset = 0}) async {
    try {
      final List<dynamic> res = await supabase
          .from('games')
          .select('*, moves(*)')
          .eq('user_id', supabase.auth.currentUser!.id)
          .order('played_at', ascending: false)
          .range(offset, offset + limit - 1);
      return List<Map<String, dynamic>>.from(res);
    } catch (_) {
      return [];
    }
  }
}
