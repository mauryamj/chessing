import 'dart:convert';
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/historical_matches_table.dart';
import '../../../features/roleplay/models/historical_match_model.dart';

part 'historical_matches_dao.g.dart';

@DriftAccessor(tables: [HistoricalMatches])
class HistoricalMatchesDao extends DatabaseAccessor<AppDatabase>
    with _$HistoricalMatchesDaoMixin {
  HistoricalMatchesDao(super.db);

  Future<List<HistoricalMatchModel>> getAll() async {
    final rows = await (select(historicalMatches)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
    return rows.map(_fromRow).toList();
  }

  Future<void> upsertAll(List<HistoricalMatchModel> matches) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(
        historicalMatches,
        matches.map(_toCompanion).toList(),
      );
    });
  }

  HistoricalMatchModel _fromRow(LocalHistoricalMatch row) =>
      HistoricalMatchModel(
        id: row.id,
        whitePlayer: row.whitePlayer,
        blackPlayer: row.blackPlayer,
        event: row.event,
        year: row.year,
        result: row.result,
        pgn: row.pgn,
        description: row.description,
        tags: List<String>.from(jsonDecode(row.tagsJson)),
        difficulty: row.difficulty,
        sortOrder: row.sortOrder,
      );

  HistoricalMatchesCompanion _toCompanion(HistoricalMatchModel m) =>
      HistoricalMatchesCompanion.insert(
        id: m.id,
        whitePlayer: m.whitePlayer,
        blackPlayer: m.blackPlayer,
        event: m.event,
        year: m.year,
        result: m.result,
        pgn: m.pgn,
        description: m.description,
        tagsJson: jsonEncode(m.tags),
        difficulty: m.difficulty,
        sortOrder: m.sortOrder,
      );
}
