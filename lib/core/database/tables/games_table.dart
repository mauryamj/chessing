import 'package:drift/drift.dart';

class Games extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get pgn => text()();
  TextColumn get result => text()(); // '1-0' | '0-1' | '1/2-1/2'
  TextColumn get mode => text()(); // 'timed' | 'free' | 'level'
  IntColumn get botLevel => integer().nullable()();
  IntColumn get timeControlSeconds => integer().nullable()();
  DateTimeColumn get playedAt => dateTime()();
  IntColumn get playerAccuracy => integer().nullable()();
  IntColumn get playerColorIndex => integer().withDefault(const Constant(0))(); // 0 for White, 1 for Black
}
