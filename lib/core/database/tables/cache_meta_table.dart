import 'package:drift/drift.dart';

class CacheMeta extends Table {
  // e.g. 'theory_entries', 'historical_matches', 'profile', 'match_history'
  TextColumn get key => text()();
  DateTimeColumn get lastFetchedAt => dateTime()();
  IntColumn get recordCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {key};
}
