import 'dart:convert';
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/theory_entries_table.dart';
import '../tables/theory_user_data_table.dart';
import '../../../features/theory/models/theory_entry.dart';

part 'theory_dao.g.dart';

@DriftAccessor(tables: [TheoryEntries, TheoryUserData])
class TheoryDao extends DatabaseAccessor<AppDatabase> with _$TheoryDaoMixin {
  TheoryDao(super.db);

  Future<List<TheoryEntry>> getAll() async {
    final rows = await select(theoryEntries).get();
    return rows.map(_fromRow).toList();
  }

  Future<List<TheoryEntry>> getByPhase(String phase) async {
    final rows = await (select(theoryEntries)
          ..where((t) => t.phase.equals(phase))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
    return rows.map(_fromRow).toList();
  }

  Future<void> upsertAll(List<TheoryEntry> entries) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(
        theoryEntries,
        entries.map(_toCompanion).toList(),
      );
    });
  }

  Future<LocalTheoryUserData?> getUserData(String theoryId) async {
    return await (select(theoryUserData)
          ..where((t) => t.theoryId.equals(theoryId)))
        .getSingleOrNull();
  }

  Future<void> setBookmark(String theoryId, bool value) async {
    await into(theoryUserData).insertOnConflictUpdate(
      TheoryUserDataCompanion.insert(
        theoryId: theoryId,
        isBookmarked: Value(value),
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> setCompleted(String theoryId) async {
    await into(theoryUserData).insertOnConflictUpdate(
      TheoryUserDataCompanion.insert(
        theoryId: theoryId,
        isCompleted: const Value(true),
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<Map<String, LocalTheoryUserData>> getAllUserData() async {
    final rows = await select(theoryUserData).get();
    return {for (final r in rows) r.theoryId: r};
  }

  TheoryEntry _fromRow(LocalTheoryEntry row) => TheoryEntry(
        id: row.id,
        phase: row.phase,
        title: row.title,
        subtitle: row.subtitle,
        summary: row.summary,
        moves: List<String>.from(jsonDecode(row.movesJson)),
        keyIdeas: List<String>.from(jsonDecode(row.keyIdeasJson)),
        variations: (jsonDecode(row.variationsJson) as List)
            .map((v) => TheoryVariation.fromJson(v as Map<String, dynamic>))
            .toList(),
        difficulty: row.difficulty,
        tags: List<String>.from(jsonDecode(row.tagsJson)),
        sortOrder: row.sortOrder,
      );

  TheoryEntriesCompanion _toCompanion(TheoryEntry e) =>
      TheoryEntriesCompanion.insert(
        id: e.id,
        phase: e.phase,
        title: e.title,
        subtitle: Value(e.subtitle),
        summary: e.summary,
        movesJson: jsonEncode(e.moves),
        keyIdeasJson: jsonEncode(e.keyIdeas),
        variationsJson: jsonEncode(e.variations.map((v) => v.toJson()).toList()),
        difficulty: e.difficulty,
        tagsJson: jsonEncode(e.tags),
        sortOrder: e.sortOrder,
      );
}
