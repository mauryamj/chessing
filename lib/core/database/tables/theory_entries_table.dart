import 'package:drift/drift.dart';

@DataClassName('LocalTheoryEntry')
class TheoryEntries extends Table {
  TextColumn get id => text()();
  TextColumn get phase => text()();
  TextColumn get title => text()();
  TextColumn get subtitle => text().nullable()();
  TextColumn get summary => text()();
  TextColumn get movesJson => text()();           // JSON-encoded List<String>
  TextColumn get keyIdeasJson => text()();        // JSON-encoded List<String>
  TextColumn get variationsJson => text()();      // JSON-encoded List<Map>
  TextColumn get difficulty => text()();
  TextColumn get tagsJson => text()();            // JSON-encoded List<String>
  IntColumn get sortOrder => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
