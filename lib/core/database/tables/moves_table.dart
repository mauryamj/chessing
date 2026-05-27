import 'package:drift/drift.dart';
import 'games_table.dart';

class Moves extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get gameId => integer().references(Games, #id)();
  IntColumn get ply => integer()();
  TextColumn get uci => text()();
  TextColumn get san => text()();
  IntColumn get evalCentipawns => integer().nullable()();
  TextColumn get classification => text().nullable()(); // 'best'|'good'|'inaccuracy'|'mistake'|'blunder'
}
