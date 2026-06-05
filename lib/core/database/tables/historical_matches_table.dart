import 'package:drift/drift.dart';

@DataClassName('LocalHistoricalMatch')
class HistoricalMatches extends Table {
  TextColumn get id => text()();
  TextColumn get whitePlayer => text()();
  TextColumn get blackPlayer => text()();
  TextColumn get event => text()();
  IntColumn get year => integer()();
  TextColumn get result => text()();
  TextColumn get pgn => text()();
  TextColumn get description => text()();
  TextColumn get tagsJson => text()();
  TextColumn get difficulty => text()();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
