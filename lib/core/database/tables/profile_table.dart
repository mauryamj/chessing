import 'package:drift/drift.dart';

class Profile extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().withDefault(const Constant('Player'))();
  TextColumn get avatarPath => text().nullable()();
  IntColumn get currentRating => integer().withDefault(const Constant(800))();
  IntColumn get peakRating => integer().withDefault(const Constant(800))();
  IntColumn get gamesPlayed => integer().withDefault(const Constant(0))();
  IntColumn get wins => integer().withDefault(const Constant(0))();
  IntColumn get draws => integer().withDefault(const Constant(0))();
  IntColumn get losses => integer().withDefault(const Constant(0))();
  TextColumn get remoteId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}
