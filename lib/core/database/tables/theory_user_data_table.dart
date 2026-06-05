import 'package:drift/drift.dart';

@DataClassName('LocalTheoryUserData')
class TheoryUserData extends Table {
  TextColumn get theoryId => text()();
  BoolColumn get isBookmarked => boolean().withDefault(const Constant(false))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {theoryId};
}
