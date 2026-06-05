// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $GamesTable extends Games with TableInfo<$GamesTable, Game> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _pgnMeta = const VerificationMeta('pgn');
  @override
  late final GeneratedColumn<String> pgn = GeneratedColumn<String>(
      'pgn', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _resultMeta = const VerificationMeta('result');
  @override
  late final GeneratedColumn<String> result = GeneratedColumn<String>(
      'result', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
      'mode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _botLevelMeta =
      const VerificationMeta('botLevel');
  @override
  late final GeneratedColumn<int> botLevel = GeneratedColumn<int>(
      'bot_level', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _timeControlSecondsMeta =
      const VerificationMeta('timeControlSeconds');
  @override
  late final GeneratedColumn<int> timeControlSeconds = GeneratedColumn<int>(
      'time_control_seconds', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _playedAtMeta =
      const VerificationMeta('playedAt');
  @override
  late final GeneratedColumn<DateTime> playedAt = GeneratedColumn<DateTime>(
      'played_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _playerAccuracyMeta =
      const VerificationMeta('playerAccuracy');
  @override
  late final GeneratedColumn<int> playerAccuracy = GeneratedColumn<int>(
      'player_accuracy', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _playerColorIndexMeta =
      const VerificationMeta('playerColorIndex');
  @override
  late final GeneratedColumn<int> playerColorIndex = GeneratedColumn<int>(
      'player_color_index', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pendingSyncMeta =
      const VerificationMeta('pendingSync');
  @override
  late final GeneratedColumn<bool> pendingSync = GeneratedColumn<bool>(
      'pending_sync', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("pending_sync" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _fenMeta = const VerificationMeta('fen');
  @override
  late final GeneratedColumn<String> fen = GeneratedColumn<String>(
      'fen', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(
          'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        pgn,
        result,
        mode,
        botLevel,
        timeControlSeconds,
        playedAt,
        playerAccuracy,
        playerColorIndex,
        remoteId,
        pendingSync,
        fen,
        isActive
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'games';
  @override
  VerificationContext validateIntegrity(Insertable<Game> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pgn')) {
      context.handle(
          _pgnMeta, pgn.isAcceptableOrUnknown(data['pgn']!, _pgnMeta));
    } else if (isInserting) {
      context.missing(_pgnMeta);
    }
    if (data.containsKey('result')) {
      context.handle(_resultMeta,
          result.isAcceptableOrUnknown(data['result']!, _resultMeta));
    } else if (isInserting) {
      context.missing(_resultMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
          _modeMeta, mode.isAcceptableOrUnknown(data['mode']!, _modeMeta));
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('bot_level')) {
      context.handle(_botLevelMeta,
          botLevel.isAcceptableOrUnknown(data['bot_level']!, _botLevelMeta));
    }
    if (data.containsKey('time_control_seconds')) {
      context.handle(
          _timeControlSecondsMeta,
          timeControlSeconds.isAcceptableOrUnknown(
              data['time_control_seconds']!, _timeControlSecondsMeta));
    }
    if (data.containsKey('played_at')) {
      context.handle(_playedAtMeta,
          playedAt.isAcceptableOrUnknown(data['played_at']!, _playedAtMeta));
    } else if (isInserting) {
      context.missing(_playedAtMeta);
    }
    if (data.containsKey('player_accuracy')) {
      context.handle(
          _playerAccuracyMeta,
          playerAccuracy.isAcceptableOrUnknown(
              data['player_accuracy']!, _playerAccuracyMeta));
    }
    if (data.containsKey('player_color_index')) {
      context.handle(
          _playerColorIndexMeta,
          playerColorIndex.isAcceptableOrUnknown(
              data['player_color_index']!, _playerColorIndexMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('pending_sync')) {
      context.handle(
          _pendingSyncMeta,
          pendingSync.isAcceptableOrUnknown(
              data['pending_sync']!, _pendingSyncMeta));
    }
    if (data.containsKey('fen')) {
      context.handle(
          _fenMeta, fen.isAcceptableOrUnknown(data['fen']!, _fenMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Game map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Game(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      pgn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pgn'])!,
      result: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}result'])!,
      mode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mode'])!,
      botLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bot_level']),
      timeControlSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}time_control_seconds']),
      playedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}played_at'])!,
      playerAccuracy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}player_accuracy']),
      playerColorIndex: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}player_color_index'])!,
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
      pendingSync: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}pending_sync'])!,
      fen: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fen'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $GamesTable createAlias(String alias) {
    return $GamesTable(attachedDatabase, alias);
  }
}

class Game extends DataClass implements Insertable<Game> {
  final int id;
  final String pgn;
  final String result;
  final String mode;
  final int? botLevel;
  final int? timeControlSeconds;
  final DateTime playedAt;
  final int? playerAccuracy;
  final int playerColorIndex;
  final String? remoteId;
  final bool pendingSync;
  final String fen;
  final bool isActive;
  const Game(
      {required this.id,
      required this.pgn,
      required this.result,
      required this.mode,
      this.botLevel,
      this.timeControlSeconds,
      required this.playedAt,
      this.playerAccuracy,
      required this.playerColorIndex,
      this.remoteId,
      required this.pendingSync,
      required this.fen,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pgn'] = Variable<String>(pgn);
    map['result'] = Variable<String>(result);
    map['mode'] = Variable<String>(mode);
    if (!nullToAbsent || botLevel != null) {
      map['bot_level'] = Variable<int>(botLevel);
    }
    if (!nullToAbsent || timeControlSeconds != null) {
      map['time_control_seconds'] = Variable<int>(timeControlSeconds);
    }
    map['played_at'] = Variable<DateTime>(playedAt);
    if (!nullToAbsent || playerAccuracy != null) {
      map['player_accuracy'] = Variable<int>(playerAccuracy);
    }
    map['player_color_index'] = Variable<int>(playerColorIndex);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['pending_sync'] = Variable<bool>(pendingSync);
    map['fen'] = Variable<String>(fen);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  GamesCompanion toCompanion(bool nullToAbsent) {
    return GamesCompanion(
      id: Value(id),
      pgn: Value(pgn),
      result: Value(result),
      mode: Value(mode),
      botLevel: botLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(botLevel),
      timeControlSeconds: timeControlSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(timeControlSeconds),
      playedAt: Value(playedAt),
      playerAccuracy: playerAccuracy == null && nullToAbsent
          ? const Value.absent()
          : Value(playerAccuracy),
      playerColorIndex: Value(playerColorIndex),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      pendingSync: Value(pendingSync),
      fen: Value(fen),
      isActive: Value(isActive),
    );
  }

  factory Game.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Game(
      id: serializer.fromJson<int>(json['id']),
      pgn: serializer.fromJson<String>(json['pgn']),
      result: serializer.fromJson<String>(json['result']),
      mode: serializer.fromJson<String>(json['mode']),
      botLevel: serializer.fromJson<int?>(json['botLevel']),
      timeControlSeconds: serializer.fromJson<int?>(json['timeControlSeconds']),
      playedAt: serializer.fromJson<DateTime>(json['playedAt']),
      playerAccuracy: serializer.fromJson<int?>(json['playerAccuracy']),
      playerColorIndex: serializer.fromJson<int>(json['playerColorIndex']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      pendingSync: serializer.fromJson<bool>(json['pendingSync']),
      fen: serializer.fromJson<String>(json['fen']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pgn': serializer.toJson<String>(pgn),
      'result': serializer.toJson<String>(result),
      'mode': serializer.toJson<String>(mode),
      'botLevel': serializer.toJson<int?>(botLevel),
      'timeControlSeconds': serializer.toJson<int?>(timeControlSeconds),
      'playedAt': serializer.toJson<DateTime>(playedAt),
      'playerAccuracy': serializer.toJson<int?>(playerAccuracy),
      'playerColorIndex': serializer.toJson<int>(playerColorIndex),
      'remoteId': serializer.toJson<String?>(remoteId),
      'pendingSync': serializer.toJson<bool>(pendingSync),
      'fen': serializer.toJson<String>(fen),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Game copyWith(
          {int? id,
          String? pgn,
          String? result,
          String? mode,
          Value<int?> botLevel = const Value.absent(),
          Value<int?> timeControlSeconds = const Value.absent(),
          DateTime? playedAt,
          Value<int?> playerAccuracy = const Value.absent(),
          int? playerColorIndex,
          Value<String?> remoteId = const Value.absent(),
          bool? pendingSync,
          String? fen,
          bool? isActive}) =>
      Game(
        id: id ?? this.id,
        pgn: pgn ?? this.pgn,
        result: result ?? this.result,
        mode: mode ?? this.mode,
        botLevel: botLevel.present ? botLevel.value : this.botLevel,
        timeControlSeconds: timeControlSeconds.present
            ? timeControlSeconds.value
            : this.timeControlSeconds,
        playedAt: playedAt ?? this.playedAt,
        playerAccuracy:
            playerAccuracy.present ? playerAccuracy.value : this.playerAccuracy,
        playerColorIndex: playerColorIndex ?? this.playerColorIndex,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        pendingSync: pendingSync ?? this.pendingSync,
        fen: fen ?? this.fen,
        isActive: isActive ?? this.isActive,
      );
  Game copyWithCompanion(GamesCompanion data) {
    return Game(
      id: data.id.present ? data.id.value : this.id,
      pgn: data.pgn.present ? data.pgn.value : this.pgn,
      result: data.result.present ? data.result.value : this.result,
      mode: data.mode.present ? data.mode.value : this.mode,
      botLevel: data.botLevel.present ? data.botLevel.value : this.botLevel,
      timeControlSeconds: data.timeControlSeconds.present
          ? data.timeControlSeconds.value
          : this.timeControlSeconds,
      playedAt: data.playedAt.present ? data.playedAt.value : this.playedAt,
      playerAccuracy: data.playerAccuracy.present
          ? data.playerAccuracy.value
          : this.playerAccuracy,
      playerColorIndex: data.playerColorIndex.present
          ? data.playerColorIndex.value
          : this.playerColorIndex,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      pendingSync:
          data.pendingSync.present ? data.pendingSync.value : this.pendingSync,
      fen: data.fen.present ? data.fen.value : this.fen,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Game(')
          ..write('id: $id, ')
          ..write('pgn: $pgn, ')
          ..write('result: $result, ')
          ..write('mode: $mode, ')
          ..write('botLevel: $botLevel, ')
          ..write('timeControlSeconds: $timeControlSeconds, ')
          ..write('playedAt: $playedAt, ')
          ..write('playerAccuracy: $playerAccuracy, ')
          ..write('playerColorIndex: $playerColorIndex, ')
          ..write('remoteId: $remoteId, ')
          ..write('pendingSync: $pendingSync, ')
          ..write('fen: $fen, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      pgn,
      result,
      mode,
      botLevel,
      timeControlSeconds,
      playedAt,
      playerAccuracy,
      playerColorIndex,
      remoteId,
      pendingSync,
      fen,
      isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Game &&
          other.id == this.id &&
          other.pgn == this.pgn &&
          other.result == this.result &&
          other.mode == this.mode &&
          other.botLevel == this.botLevel &&
          other.timeControlSeconds == this.timeControlSeconds &&
          other.playedAt == this.playedAt &&
          other.playerAccuracy == this.playerAccuracy &&
          other.playerColorIndex == this.playerColorIndex &&
          other.remoteId == this.remoteId &&
          other.pendingSync == this.pendingSync &&
          other.fen == this.fen &&
          other.isActive == this.isActive);
}

class GamesCompanion extends UpdateCompanion<Game> {
  final Value<int> id;
  final Value<String> pgn;
  final Value<String> result;
  final Value<String> mode;
  final Value<int?> botLevel;
  final Value<int?> timeControlSeconds;
  final Value<DateTime> playedAt;
  final Value<int?> playerAccuracy;
  final Value<int> playerColorIndex;
  final Value<String?> remoteId;
  final Value<bool> pendingSync;
  final Value<String> fen;
  final Value<bool> isActive;
  const GamesCompanion({
    this.id = const Value.absent(),
    this.pgn = const Value.absent(),
    this.result = const Value.absent(),
    this.mode = const Value.absent(),
    this.botLevel = const Value.absent(),
    this.timeControlSeconds = const Value.absent(),
    this.playedAt = const Value.absent(),
    this.playerAccuracy = const Value.absent(),
    this.playerColorIndex = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.pendingSync = const Value.absent(),
    this.fen = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  GamesCompanion.insert({
    this.id = const Value.absent(),
    required String pgn,
    required String result,
    required String mode,
    this.botLevel = const Value.absent(),
    this.timeControlSeconds = const Value.absent(),
    required DateTime playedAt,
    this.playerAccuracy = const Value.absent(),
    this.playerColorIndex = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.pendingSync = const Value.absent(),
    this.fen = const Value.absent(),
    this.isActive = const Value.absent(),
  })  : pgn = Value(pgn),
        result = Value(result),
        mode = Value(mode),
        playedAt = Value(playedAt);
  static Insertable<Game> custom({
    Expression<int>? id,
    Expression<String>? pgn,
    Expression<String>? result,
    Expression<String>? mode,
    Expression<int>? botLevel,
    Expression<int>? timeControlSeconds,
    Expression<DateTime>? playedAt,
    Expression<int>? playerAccuracy,
    Expression<int>? playerColorIndex,
    Expression<String>? remoteId,
    Expression<bool>? pendingSync,
    Expression<String>? fen,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pgn != null) 'pgn': pgn,
      if (result != null) 'result': result,
      if (mode != null) 'mode': mode,
      if (botLevel != null) 'bot_level': botLevel,
      if (timeControlSeconds != null)
        'time_control_seconds': timeControlSeconds,
      if (playedAt != null) 'played_at': playedAt,
      if (playerAccuracy != null) 'player_accuracy': playerAccuracy,
      if (playerColorIndex != null) 'player_color_index': playerColorIndex,
      if (remoteId != null) 'remote_id': remoteId,
      if (pendingSync != null) 'pending_sync': pendingSync,
      if (fen != null) 'fen': fen,
      if (isActive != null) 'is_active': isActive,
    });
  }

  GamesCompanion copyWith(
      {Value<int>? id,
      Value<String>? pgn,
      Value<String>? result,
      Value<String>? mode,
      Value<int?>? botLevel,
      Value<int?>? timeControlSeconds,
      Value<DateTime>? playedAt,
      Value<int?>? playerAccuracy,
      Value<int>? playerColorIndex,
      Value<String?>? remoteId,
      Value<bool>? pendingSync,
      Value<String>? fen,
      Value<bool>? isActive}) {
    return GamesCompanion(
      id: id ?? this.id,
      pgn: pgn ?? this.pgn,
      result: result ?? this.result,
      mode: mode ?? this.mode,
      botLevel: botLevel ?? this.botLevel,
      timeControlSeconds: timeControlSeconds ?? this.timeControlSeconds,
      playedAt: playedAt ?? this.playedAt,
      playerAccuracy: playerAccuracy ?? this.playerAccuracy,
      playerColorIndex: playerColorIndex ?? this.playerColorIndex,
      remoteId: remoteId ?? this.remoteId,
      pendingSync: pendingSync ?? this.pendingSync,
      fen: fen ?? this.fen,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pgn.present) {
      map['pgn'] = Variable<String>(pgn.value);
    }
    if (result.present) {
      map['result'] = Variable<String>(result.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (botLevel.present) {
      map['bot_level'] = Variable<int>(botLevel.value);
    }
    if (timeControlSeconds.present) {
      map['time_control_seconds'] = Variable<int>(timeControlSeconds.value);
    }
    if (playedAt.present) {
      map['played_at'] = Variable<DateTime>(playedAt.value);
    }
    if (playerAccuracy.present) {
      map['player_accuracy'] = Variable<int>(playerAccuracy.value);
    }
    if (playerColorIndex.present) {
      map['player_color_index'] = Variable<int>(playerColorIndex.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (pendingSync.present) {
      map['pending_sync'] = Variable<bool>(pendingSync.value);
    }
    if (fen.present) {
      map['fen'] = Variable<String>(fen.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamesCompanion(')
          ..write('id: $id, ')
          ..write('pgn: $pgn, ')
          ..write('result: $result, ')
          ..write('mode: $mode, ')
          ..write('botLevel: $botLevel, ')
          ..write('timeControlSeconds: $timeControlSeconds, ')
          ..write('playedAt: $playedAt, ')
          ..write('playerAccuracy: $playerAccuracy, ')
          ..write('playerColorIndex: $playerColorIndex, ')
          ..write('remoteId: $remoteId, ')
          ..write('pendingSync: $pendingSync, ')
          ..write('fen: $fen, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $MovesTable extends Moves with TableInfo<$MovesTable, Move> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MovesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<int> gameId = GeneratedColumn<int>(
      'game_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES games (id)'));
  static const VerificationMeta _plyMeta = const VerificationMeta('ply');
  @override
  late final GeneratedColumn<int> ply = GeneratedColumn<int>(
      'ply', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _uciMeta = const VerificationMeta('uci');
  @override
  late final GeneratedColumn<String> uci = GeneratedColumn<String>(
      'uci', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sanMeta = const VerificationMeta('san');
  @override
  late final GeneratedColumn<String> san = GeneratedColumn<String>(
      'san', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _evalCentipawnsMeta =
      const VerificationMeta('evalCentipawns');
  @override
  late final GeneratedColumn<int> evalCentipawns = GeneratedColumn<int>(
      'eval_centipawns', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _classificationMeta =
      const VerificationMeta('classification');
  @override
  late final GeneratedColumn<String> classification = GeneratedColumn<String>(
      'classification', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _bestMoveUciMeta =
      const VerificationMeta('bestMoveUci');
  @override
  late final GeneratedColumn<String> bestMoveUci = GeneratedColumn<String>(
      'best_move_uci', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, gameId, ply, uci, san, evalCentipawns, classification, bestMoveUci];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'moves';
  @override
  VerificationContext validateIntegrity(Insertable<Move> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('game_id')) {
      context.handle(_gameIdMeta,
          gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta));
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('ply')) {
      context.handle(
          _plyMeta, ply.isAcceptableOrUnknown(data['ply']!, _plyMeta));
    } else if (isInserting) {
      context.missing(_plyMeta);
    }
    if (data.containsKey('uci')) {
      context.handle(
          _uciMeta, uci.isAcceptableOrUnknown(data['uci']!, _uciMeta));
    } else if (isInserting) {
      context.missing(_uciMeta);
    }
    if (data.containsKey('san')) {
      context.handle(
          _sanMeta, san.isAcceptableOrUnknown(data['san']!, _sanMeta));
    } else if (isInserting) {
      context.missing(_sanMeta);
    }
    if (data.containsKey('eval_centipawns')) {
      context.handle(
          _evalCentipawnsMeta,
          evalCentipawns.isAcceptableOrUnknown(
              data['eval_centipawns']!, _evalCentipawnsMeta));
    }
    if (data.containsKey('classification')) {
      context.handle(
          _classificationMeta,
          classification.isAcceptableOrUnknown(
              data['classification']!, _classificationMeta));
    }
    if (data.containsKey('best_move_uci')) {
      context.handle(
          _bestMoveUciMeta,
          bestMoveUci.isAcceptableOrUnknown(
              data['best_move_uci']!, _bestMoveUciMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Move map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Move(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      gameId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}game_id'])!,
      ply: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ply'])!,
      uci: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uci'])!,
      san: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}san'])!,
      evalCentipawns: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}eval_centipawns']),
      classification: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}classification']),
      bestMoveUci: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}best_move_uci']),
    );
  }

  @override
  $MovesTable createAlias(String alias) {
    return $MovesTable(attachedDatabase, alias);
  }
}

class Move extends DataClass implements Insertable<Move> {
  final int id;
  final int gameId;
  final int ply;
  final String uci;
  final String san;
  final int? evalCentipawns;
  final String? classification;
  final String? bestMoveUci;
  const Move(
      {required this.id,
      required this.gameId,
      required this.ply,
      required this.uci,
      required this.san,
      this.evalCentipawns,
      this.classification,
      this.bestMoveUci});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['game_id'] = Variable<int>(gameId);
    map['ply'] = Variable<int>(ply);
    map['uci'] = Variable<String>(uci);
    map['san'] = Variable<String>(san);
    if (!nullToAbsent || evalCentipawns != null) {
      map['eval_centipawns'] = Variable<int>(evalCentipawns);
    }
    if (!nullToAbsent || classification != null) {
      map['classification'] = Variable<String>(classification);
    }
    if (!nullToAbsent || bestMoveUci != null) {
      map['best_move_uci'] = Variable<String>(bestMoveUci);
    }
    return map;
  }

  MovesCompanion toCompanion(bool nullToAbsent) {
    return MovesCompanion(
      id: Value(id),
      gameId: Value(gameId),
      ply: Value(ply),
      uci: Value(uci),
      san: Value(san),
      evalCentipawns: evalCentipawns == null && nullToAbsent
          ? const Value.absent()
          : Value(evalCentipawns),
      classification: classification == null && nullToAbsent
          ? const Value.absent()
          : Value(classification),
      bestMoveUci: bestMoveUci == null && nullToAbsent
          ? const Value.absent()
          : Value(bestMoveUci),
    );
  }

  factory Move.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Move(
      id: serializer.fromJson<int>(json['id']),
      gameId: serializer.fromJson<int>(json['gameId']),
      ply: serializer.fromJson<int>(json['ply']),
      uci: serializer.fromJson<String>(json['uci']),
      san: serializer.fromJson<String>(json['san']),
      evalCentipawns: serializer.fromJson<int?>(json['evalCentipawns']),
      classification: serializer.fromJson<String?>(json['classification']),
      bestMoveUci: serializer.fromJson<String?>(json['bestMoveUci']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'gameId': serializer.toJson<int>(gameId),
      'ply': serializer.toJson<int>(ply),
      'uci': serializer.toJson<String>(uci),
      'san': serializer.toJson<String>(san),
      'evalCentipawns': serializer.toJson<int?>(evalCentipawns),
      'classification': serializer.toJson<String?>(classification),
      'bestMoveUci': serializer.toJson<String?>(bestMoveUci),
    };
  }

  Move copyWith(
          {int? id,
          int? gameId,
          int? ply,
          String? uci,
          String? san,
          Value<int?> evalCentipawns = const Value.absent(),
          Value<String?> classification = const Value.absent(),
          Value<String?> bestMoveUci = const Value.absent()}) =>
      Move(
        id: id ?? this.id,
        gameId: gameId ?? this.gameId,
        ply: ply ?? this.ply,
        uci: uci ?? this.uci,
        san: san ?? this.san,
        evalCentipawns:
            evalCentipawns.present ? evalCentipawns.value : this.evalCentipawns,
        classification:
            classification.present ? classification.value : this.classification,
        bestMoveUci: bestMoveUci.present ? bestMoveUci.value : this.bestMoveUci,
      );
  Move copyWithCompanion(MovesCompanion data) {
    return Move(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      ply: data.ply.present ? data.ply.value : this.ply,
      uci: data.uci.present ? data.uci.value : this.uci,
      san: data.san.present ? data.san.value : this.san,
      evalCentipawns: data.evalCentipawns.present
          ? data.evalCentipawns.value
          : this.evalCentipawns,
      classification: data.classification.present
          ? data.classification.value
          : this.classification,
      bestMoveUci:
          data.bestMoveUci.present ? data.bestMoveUci.value : this.bestMoveUci,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Move(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('ply: $ply, ')
          ..write('uci: $uci, ')
          ..write('san: $san, ')
          ..write('evalCentipawns: $evalCentipawns, ')
          ..write('classification: $classification, ')
          ..write('bestMoveUci: $bestMoveUci')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, gameId, ply, uci, san, evalCentipawns, classification, bestMoveUci);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Move &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.ply == this.ply &&
          other.uci == this.uci &&
          other.san == this.san &&
          other.evalCentipawns == this.evalCentipawns &&
          other.classification == this.classification &&
          other.bestMoveUci == this.bestMoveUci);
}

class MovesCompanion extends UpdateCompanion<Move> {
  final Value<int> id;
  final Value<int> gameId;
  final Value<int> ply;
  final Value<String> uci;
  final Value<String> san;
  final Value<int?> evalCentipawns;
  final Value<String?> classification;
  final Value<String?> bestMoveUci;
  const MovesCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.ply = const Value.absent(),
    this.uci = const Value.absent(),
    this.san = const Value.absent(),
    this.evalCentipawns = const Value.absent(),
    this.classification = const Value.absent(),
    this.bestMoveUci = const Value.absent(),
  });
  MovesCompanion.insert({
    this.id = const Value.absent(),
    required int gameId,
    required int ply,
    required String uci,
    required String san,
    this.evalCentipawns = const Value.absent(),
    this.classification = const Value.absent(),
    this.bestMoveUci = const Value.absent(),
  })  : gameId = Value(gameId),
        ply = Value(ply),
        uci = Value(uci),
        san = Value(san);
  static Insertable<Move> custom({
    Expression<int>? id,
    Expression<int>? gameId,
    Expression<int>? ply,
    Expression<String>? uci,
    Expression<String>? san,
    Expression<int>? evalCentipawns,
    Expression<String>? classification,
    Expression<String>? bestMoveUci,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (ply != null) 'ply': ply,
      if (uci != null) 'uci': uci,
      if (san != null) 'san': san,
      if (evalCentipawns != null) 'eval_centipawns': evalCentipawns,
      if (classification != null) 'classification': classification,
      if (bestMoveUci != null) 'best_move_uci': bestMoveUci,
    });
  }

  MovesCompanion copyWith(
      {Value<int>? id,
      Value<int>? gameId,
      Value<int>? ply,
      Value<String>? uci,
      Value<String>? san,
      Value<int?>? evalCentipawns,
      Value<String?>? classification,
      Value<String?>? bestMoveUci}) {
    return MovesCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      ply: ply ?? this.ply,
      uci: uci ?? this.uci,
      san: san ?? this.san,
      evalCentipawns: evalCentipawns ?? this.evalCentipawns,
      classification: classification ?? this.classification,
      bestMoveUci: bestMoveUci ?? this.bestMoveUci,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<int>(gameId.value);
    }
    if (ply.present) {
      map['ply'] = Variable<int>(ply.value);
    }
    if (uci.present) {
      map['uci'] = Variable<String>(uci.value);
    }
    if (san.present) {
      map['san'] = Variable<String>(san.value);
    }
    if (evalCentipawns.present) {
      map['eval_centipawns'] = Variable<int>(evalCentipawns.value);
    }
    if (classification.present) {
      map['classification'] = Variable<String>(classification.value);
    }
    if (bestMoveUci.present) {
      map['best_move_uci'] = Variable<String>(bestMoveUci.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MovesCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('ply: $ply, ')
          ..write('uci: $uci, ')
          ..write('san: $san, ')
          ..write('evalCentipawns: $evalCentipawns, ')
          ..write('classification: $classification, ')
          ..write('bestMoveUci: $bestMoveUci')
          ..write(')'))
        .toString();
  }
}

class $ProfileTable extends Profile with TableInfo<$ProfileTable, ProfileData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfileTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Player'));
  static const VerificationMeta _avatarPathMeta =
      const VerificationMeta('avatarPath');
  @override
  late final GeneratedColumn<String> avatarPath = GeneratedColumn<String>(
      'avatar_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _currentRatingMeta =
      const VerificationMeta('currentRating');
  @override
  late final GeneratedColumn<int> currentRating = GeneratedColumn<int>(
      'current_rating', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(800));
  static const VerificationMeta _peakRatingMeta =
      const VerificationMeta('peakRating');
  @override
  late final GeneratedColumn<int> peakRating = GeneratedColumn<int>(
      'peak_rating', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(800));
  static const VerificationMeta _gamesPlayedMeta =
      const VerificationMeta('gamesPlayed');
  @override
  late final GeneratedColumn<int> gamesPlayed = GeneratedColumn<int>(
      'games_played', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _winsMeta = const VerificationMeta('wins');
  @override
  late final GeneratedColumn<int> wins = GeneratedColumn<int>(
      'wins', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _drawsMeta = const VerificationMeta('draws');
  @override
  late final GeneratedColumn<int> draws = GeneratedColumn<int>(
      'draws', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lossesMeta = const VerificationMeta('losses');
  @override
  late final GeneratedColumn<int> losses = GeneratedColumn<int>(
      'losses', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        username,
        avatarPath,
        currentRating,
        peakRating,
        gamesPlayed,
        wins,
        draws,
        losses,
        remoteId,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profile';
  @override
  VerificationContext validateIntegrity(Insertable<ProfileData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    }
    if (data.containsKey('avatar_path')) {
      context.handle(
          _avatarPathMeta,
          avatarPath.isAcceptableOrUnknown(
              data['avatar_path']!, _avatarPathMeta));
    }
    if (data.containsKey('current_rating')) {
      context.handle(
          _currentRatingMeta,
          currentRating.isAcceptableOrUnknown(
              data['current_rating']!, _currentRatingMeta));
    }
    if (data.containsKey('peak_rating')) {
      context.handle(
          _peakRatingMeta,
          peakRating.isAcceptableOrUnknown(
              data['peak_rating']!, _peakRatingMeta));
    }
    if (data.containsKey('games_played')) {
      context.handle(
          _gamesPlayedMeta,
          gamesPlayed.isAcceptableOrUnknown(
              data['games_played']!, _gamesPlayedMeta));
    }
    if (data.containsKey('wins')) {
      context.handle(
          _winsMeta, wins.isAcceptableOrUnknown(data['wins']!, _winsMeta));
    }
    if (data.containsKey('draws')) {
      context.handle(
          _drawsMeta, draws.isAcceptableOrUnknown(data['draws']!, _drawsMeta));
    }
    if (data.containsKey('losses')) {
      context.handle(_lossesMeta,
          losses.isAcceptableOrUnknown(data['losses']!, _lossesMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProfileData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      avatarPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_path']),
      currentRating: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_rating'])!,
      peakRating: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}peak_rating'])!,
      gamesPlayed: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}games_played'])!,
      wins: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}wins'])!,
      draws: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}draws'])!,
      losses: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}losses'])!,
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ProfileTable createAlias(String alias) {
    return $ProfileTable(attachedDatabase, alias);
  }
}

class ProfileData extends DataClass implements Insertable<ProfileData> {
  final int id;
  final String username;
  final String? avatarPath;
  final int currentRating;
  final int peakRating;
  final int gamesPlayed;
  final int wins;
  final int draws;
  final int losses;
  final String? remoteId;
  final DateTime createdAt;
  const ProfileData(
      {required this.id,
      required this.username,
      this.avatarPath,
      required this.currentRating,
      required this.peakRating,
      required this.gamesPlayed,
      required this.wins,
      required this.draws,
      required this.losses,
      this.remoteId,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    if (!nullToAbsent || avatarPath != null) {
      map['avatar_path'] = Variable<String>(avatarPath);
    }
    map['current_rating'] = Variable<int>(currentRating);
    map['peak_rating'] = Variable<int>(peakRating);
    map['games_played'] = Variable<int>(gamesPlayed);
    map['wins'] = Variable<int>(wins);
    map['draws'] = Variable<int>(draws);
    map['losses'] = Variable<int>(losses);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProfileCompanion toCompanion(bool nullToAbsent) {
    return ProfileCompanion(
      id: Value(id),
      username: Value(username),
      avatarPath: avatarPath == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarPath),
      currentRating: Value(currentRating),
      peakRating: Value(peakRating),
      gamesPlayed: Value(gamesPlayed),
      wins: Value(wins),
      draws: Value(draws),
      losses: Value(losses),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      createdAt: Value(createdAt),
    );
  }

  factory ProfileData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileData(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      avatarPath: serializer.fromJson<String?>(json['avatarPath']),
      currentRating: serializer.fromJson<int>(json['currentRating']),
      peakRating: serializer.fromJson<int>(json['peakRating']),
      gamesPlayed: serializer.fromJson<int>(json['gamesPlayed']),
      wins: serializer.fromJson<int>(json['wins']),
      draws: serializer.fromJson<int>(json['draws']),
      losses: serializer.fromJson<int>(json['losses']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'avatarPath': serializer.toJson<String?>(avatarPath),
      'currentRating': serializer.toJson<int>(currentRating),
      'peakRating': serializer.toJson<int>(peakRating),
      'gamesPlayed': serializer.toJson<int>(gamesPlayed),
      'wins': serializer.toJson<int>(wins),
      'draws': serializer.toJson<int>(draws),
      'losses': serializer.toJson<int>(losses),
      'remoteId': serializer.toJson<String?>(remoteId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ProfileData copyWith(
          {int? id,
          String? username,
          Value<String?> avatarPath = const Value.absent(),
          int? currentRating,
          int? peakRating,
          int? gamesPlayed,
          int? wins,
          int? draws,
          int? losses,
          Value<String?> remoteId = const Value.absent(),
          DateTime? createdAt}) =>
      ProfileData(
        id: id ?? this.id,
        username: username ?? this.username,
        avatarPath: avatarPath.present ? avatarPath.value : this.avatarPath,
        currentRating: currentRating ?? this.currentRating,
        peakRating: peakRating ?? this.peakRating,
        gamesPlayed: gamesPlayed ?? this.gamesPlayed,
        wins: wins ?? this.wins,
        draws: draws ?? this.draws,
        losses: losses ?? this.losses,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        createdAt: createdAt ?? this.createdAt,
      );
  ProfileData copyWithCompanion(ProfileCompanion data) {
    return ProfileData(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      avatarPath:
          data.avatarPath.present ? data.avatarPath.value : this.avatarPath,
      currentRating: data.currentRating.present
          ? data.currentRating.value
          : this.currentRating,
      peakRating:
          data.peakRating.present ? data.peakRating.value : this.peakRating,
      gamesPlayed:
          data.gamesPlayed.present ? data.gamesPlayed.value : this.gamesPlayed,
      wins: data.wins.present ? data.wins.value : this.wins,
      draws: data.draws.present ? data.draws.value : this.draws,
      losses: data.losses.present ? data.losses.value : this.losses,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileData(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('currentRating: $currentRating, ')
          ..write('peakRating: $peakRating, ')
          ..write('gamesPlayed: $gamesPlayed, ')
          ..write('wins: $wins, ')
          ..write('draws: $draws, ')
          ..write('losses: $losses, ')
          ..write('remoteId: $remoteId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, username, avatarPath, currentRating,
      peakRating, gamesPlayed, wins, draws, losses, remoteId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileData &&
          other.id == this.id &&
          other.username == this.username &&
          other.avatarPath == this.avatarPath &&
          other.currentRating == this.currentRating &&
          other.peakRating == this.peakRating &&
          other.gamesPlayed == this.gamesPlayed &&
          other.wins == this.wins &&
          other.draws == this.draws &&
          other.losses == this.losses &&
          other.remoteId == this.remoteId &&
          other.createdAt == this.createdAt);
}

class ProfileCompanion extends UpdateCompanion<ProfileData> {
  final Value<int> id;
  final Value<String> username;
  final Value<String?> avatarPath;
  final Value<int> currentRating;
  final Value<int> peakRating;
  final Value<int> gamesPlayed;
  final Value<int> wins;
  final Value<int> draws;
  final Value<int> losses;
  final Value<String?> remoteId;
  final Value<DateTime> createdAt;
  const ProfileCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.currentRating = const Value.absent(),
    this.peakRating = const Value.absent(),
    this.gamesPlayed = const Value.absent(),
    this.wins = const Value.absent(),
    this.draws = const Value.absent(),
    this.losses = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProfileCompanion.insert({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.currentRating = const Value.absent(),
    this.peakRating = const Value.absent(),
    this.gamesPlayed = const Value.absent(),
    this.wins = const Value.absent(),
    this.draws = const Value.absent(),
    this.losses = const Value.absent(),
    this.remoteId = const Value.absent(),
    required DateTime createdAt,
  }) : createdAt = Value(createdAt);
  static Insertable<ProfileData> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? avatarPath,
    Expression<int>? currentRating,
    Expression<int>? peakRating,
    Expression<int>? gamesPlayed,
    Expression<int>? wins,
    Expression<int>? draws,
    Expression<int>? losses,
    Expression<String>? remoteId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (avatarPath != null) 'avatar_path': avatarPath,
      if (currentRating != null) 'current_rating': currentRating,
      if (peakRating != null) 'peak_rating': peakRating,
      if (gamesPlayed != null) 'games_played': gamesPlayed,
      if (wins != null) 'wins': wins,
      if (draws != null) 'draws': draws,
      if (losses != null) 'losses': losses,
      if (remoteId != null) 'remote_id': remoteId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProfileCompanion copyWith(
      {Value<int>? id,
      Value<String>? username,
      Value<String?>? avatarPath,
      Value<int>? currentRating,
      Value<int>? peakRating,
      Value<int>? gamesPlayed,
      Value<int>? wins,
      Value<int>? draws,
      Value<int>? losses,
      Value<String?>? remoteId,
      Value<DateTime>? createdAt}) {
    return ProfileCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      avatarPath: avatarPath ?? this.avatarPath,
      currentRating: currentRating ?? this.currentRating,
      peakRating: peakRating ?? this.peakRating,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      wins: wins ?? this.wins,
      draws: draws ?? this.draws,
      losses: losses ?? this.losses,
      remoteId: remoteId ?? this.remoteId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (avatarPath.present) {
      map['avatar_path'] = Variable<String>(avatarPath.value);
    }
    if (currentRating.present) {
      map['current_rating'] = Variable<int>(currentRating.value);
    }
    if (peakRating.present) {
      map['peak_rating'] = Variable<int>(peakRating.value);
    }
    if (gamesPlayed.present) {
      map['games_played'] = Variable<int>(gamesPlayed.value);
    }
    if (wins.present) {
      map['wins'] = Variable<int>(wins.value);
    }
    if (draws.present) {
      map['draws'] = Variable<int>(draws.value);
    }
    if (losses.present) {
      map['losses'] = Variable<int>(losses.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfileCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('currentRating: $currentRating, ')
          ..write('peakRating: $peakRating, ')
          ..write('gamesPlayed: $gamesPlayed, ')
          ..write('wins: $wins, ')
          ..write('draws: $draws, ')
          ..write('losses: $losses, ')
          ..write('remoteId: $remoteId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CacheMetaTable extends CacheMeta
    with TableInfo<$CacheMetaTable, CacheMetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CacheMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastFetchedAtMeta =
      const VerificationMeta('lastFetchedAt');
  @override
  late final GeneratedColumn<DateTime> lastFetchedAt =
      GeneratedColumn<DateTime>('last_fetched_at', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _recordCountMeta =
      const VerificationMeta('recordCount');
  @override
  late final GeneratedColumn<int> recordCount = GeneratedColumn<int>(
      'record_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [key, lastFetchedAt, recordCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cache_meta';
  @override
  VerificationContext validateIntegrity(Insertable<CacheMetaData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('last_fetched_at')) {
      context.handle(
          _lastFetchedAtMeta,
          lastFetchedAt.isAcceptableOrUnknown(
              data['last_fetched_at']!, _lastFetchedAtMeta));
    } else if (isInserting) {
      context.missing(_lastFetchedAtMeta);
    }
    if (data.containsKey('record_count')) {
      context.handle(
          _recordCountMeta,
          recordCount.isAcceptableOrUnknown(
              data['record_count']!, _recordCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  CacheMetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CacheMetaData(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      lastFetchedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_fetched_at'])!,
      recordCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}record_count'])!,
    );
  }

  @override
  $CacheMetaTable createAlias(String alias) {
    return $CacheMetaTable(attachedDatabase, alias);
  }
}

class CacheMetaData extends DataClass implements Insertable<CacheMetaData> {
  final String key;
  final DateTime lastFetchedAt;
  final int recordCount;
  const CacheMetaData(
      {required this.key,
      required this.lastFetchedAt,
      required this.recordCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['last_fetched_at'] = Variable<DateTime>(lastFetchedAt);
    map['record_count'] = Variable<int>(recordCount);
    return map;
  }

  CacheMetaCompanion toCompanion(bool nullToAbsent) {
    return CacheMetaCompanion(
      key: Value(key),
      lastFetchedAt: Value(lastFetchedAt),
      recordCount: Value(recordCount),
    );
  }

  factory CacheMetaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CacheMetaData(
      key: serializer.fromJson<String>(json['key']),
      lastFetchedAt: serializer.fromJson<DateTime>(json['lastFetchedAt']),
      recordCount: serializer.fromJson<int>(json['recordCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'lastFetchedAt': serializer.toJson<DateTime>(lastFetchedAt),
      'recordCount': serializer.toJson<int>(recordCount),
    };
  }

  CacheMetaData copyWith(
          {String? key, DateTime? lastFetchedAt, int? recordCount}) =>
      CacheMetaData(
        key: key ?? this.key,
        lastFetchedAt: lastFetchedAt ?? this.lastFetchedAt,
        recordCount: recordCount ?? this.recordCount,
      );
  CacheMetaData copyWithCompanion(CacheMetaCompanion data) {
    return CacheMetaData(
      key: data.key.present ? data.key.value : this.key,
      lastFetchedAt: data.lastFetchedAt.present
          ? data.lastFetchedAt.value
          : this.lastFetchedAt,
      recordCount:
          data.recordCount.present ? data.recordCount.value : this.recordCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CacheMetaData(')
          ..write('key: $key, ')
          ..write('lastFetchedAt: $lastFetchedAt, ')
          ..write('recordCount: $recordCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, lastFetchedAt, recordCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CacheMetaData &&
          other.key == this.key &&
          other.lastFetchedAt == this.lastFetchedAt &&
          other.recordCount == this.recordCount);
}

class CacheMetaCompanion extends UpdateCompanion<CacheMetaData> {
  final Value<String> key;
  final Value<DateTime> lastFetchedAt;
  final Value<int> recordCount;
  final Value<int> rowid;
  const CacheMetaCompanion({
    this.key = const Value.absent(),
    this.lastFetchedAt = const Value.absent(),
    this.recordCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CacheMetaCompanion.insert({
    required String key,
    required DateTime lastFetchedAt,
    this.recordCount = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        lastFetchedAt = Value(lastFetchedAt);
  static Insertable<CacheMetaData> custom({
    Expression<String>? key,
    Expression<DateTime>? lastFetchedAt,
    Expression<int>? recordCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (lastFetchedAt != null) 'last_fetched_at': lastFetchedAt,
      if (recordCount != null) 'record_count': recordCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CacheMetaCompanion copyWith(
      {Value<String>? key,
      Value<DateTime>? lastFetchedAt,
      Value<int>? recordCount,
      Value<int>? rowid}) {
    return CacheMetaCompanion(
      key: key ?? this.key,
      lastFetchedAt: lastFetchedAt ?? this.lastFetchedAt,
      recordCount: recordCount ?? this.recordCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (lastFetchedAt.present) {
      map['last_fetched_at'] = Variable<DateTime>(lastFetchedAt.value);
    }
    if (recordCount.present) {
      map['record_count'] = Variable<int>(recordCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CacheMetaCompanion(')
          ..write('key: $key, ')
          ..write('lastFetchedAt: $lastFetchedAt, ')
          ..write('recordCount: $recordCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TheoryEntriesTable extends TheoryEntries
    with TableInfo<$TheoryEntriesTable, LocalTheoryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TheoryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phaseMeta = const VerificationMeta('phase');
  @override
  late final GeneratedColumn<String> phase = GeneratedColumn<String>(
      'phase', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _subtitleMeta =
      const VerificationMeta('subtitle');
  @override
  late final GeneratedColumn<String> subtitle = GeneratedColumn<String>(
      'subtitle', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _summaryMeta =
      const VerificationMeta('summary');
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
      'summary', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _movesJsonMeta =
      const VerificationMeta('movesJson');
  @override
  late final GeneratedColumn<String> movesJson = GeneratedColumn<String>(
      'moves_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _keyIdeasJsonMeta =
      const VerificationMeta('keyIdeasJson');
  @override
  late final GeneratedColumn<String> keyIdeasJson = GeneratedColumn<String>(
      'key_ideas_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _variationsJsonMeta =
      const VerificationMeta('variationsJson');
  @override
  late final GeneratedColumn<String> variationsJson = GeneratedColumn<String>(
      'variations_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _difficultyMeta =
      const VerificationMeta('difficulty');
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
      'difficulty', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tagsJsonMeta =
      const VerificationMeta('tagsJson');
  @override
  late final GeneratedColumn<String> tagsJson = GeneratedColumn<String>(
      'tags_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        phase,
        title,
        subtitle,
        summary,
        movesJson,
        keyIdeasJson,
        variationsJson,
        difficulty,
        tagsJson,
        sortOrder
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'theory_entries';
  @override
  VerificationContext validateIntegrity(Insertable<LocalTheoryEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('phase')) {
      context.handle(
          _phaseMeta, phase.isAcceptableOrUnknown(data['phase']!, _phaseMeta));
    } else if (isInserting) {
      context.missing(_phaseMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('subtitle')) {
      context.handle(_subtitleMeta,
          subtitle.isAcceptableOrUnknown(data['subtitle']!, _subtitleMeta));
    }
    if (data.containsKey('summary')) {
      context.handle(_summaryMeta,
          summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta));
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    if (data.containsKey('moves_json')) {
      context.handle(_movesJsonMeta,
          movesJson.isAcceptableOrUnknown(data['moves_json']!, _movesJsonMeta));
    } else if (isInserting) {
      context.missing(_movesJsonMeta);
    }
    if (data.containsKey('key_ideas_json')) {
      context.handle(
          _keyIdeasJsonMeta,
          keyIdeasJson.isAcceptableOrUnknown(
              data['key_ideas_json']!, _keyIdeasJsonMeta));
    } else if (isInserting) {
      context.missing(_keyIdeasJsonMeta);
    }
    if (data.containsKey('variations_json')) {
      context.handle(
          _variationsJsonMeta,
          variationsJson.isAcceptableOrUnknown(
              data['variations_json']!, _variationsJsonMeta));
    } else if (isInserting) {
      context.missing(_variationsJsonMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
          _difficultyMeta,
          difficulty.isAcceptableOrUnknown(
              data['difficulty']!, _difficultyMeta));
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('tags_json')) {
      context.handle(_tagsJsonMeta,
          tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta));
    } else if (isInserting) {
      context.missing(_tagsJsonMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalTheoryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalTheoryEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      phase: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phase'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      subtitle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subtitle']),
      summary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}summary'])!,
      movesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}moves_json'])!,
      keyIdeasJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key_ideas_json'])!,
      variationsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}variations_json'])!,
      difficulty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}difficulty'])!,
      tagsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags_json'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $TheoryEntriesTable createAlias(String alias) {
    return $TheoryEntriesTable(attachedDatabase, alias);
  }
}

class LocalTheoryEntry extends DataClass
    implements Insertable<LocalTheoryEntry> {
  final String id;
  final String phase;
  final String title;
  final String? subtitle;
  final String summary;
  final String movesJson;
  final String keyIdeasJson;
  final String variationsJson;
  final String difficulty;
  final String tagsJson;
  final int sortOrder;
  const LocalTheoryEntry(
      {required this.id,
      required this.phase,
      required this.title,
      this.subtitle,
      required this.summary,
      required this.movesJson,
      required this.keyIdeasJson,
      required this.variationsJson,
      required this.difficulty,
      required this.tagsJson,
      required this.sortOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['phase'] = Variable<String>(phase);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || subtitle != null) {
      map['subtitle'] = Variable<String>(subtitle);
    }
    map['summary'] = Variable<String>(summary);
    map['moves_json'] = Variable<String>(movesJson);
    map['key_ideas_json'] = Variable<String>(keyIdeasJson);
    map['variations_json'] = Variable<String>(variationsJson);
    map['difficulty'] = Variable<String>(difficulty);
    map['tags_json'] = Variable<String>(tagsJson);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  TheoryEntriesCompanion toCompanion(bool nullToAbsent) {
    return TheoryEntriesCompanion(
      id: Value(id),
      phase: Value(phase),
      title: Value(title),
      subtitle: subtitle == null && nullToAbsent
          ? const Value.absent()
          : Value(subtitle),
      summary: Value(summary),
      movesJson: Value(movesJson),
      keyIdeasJson: Value(keyIdeasJson),
      variationsJson: Value(variationsJson),
      difficulty: Value(difficulty),
      tagsJson: Value(tagsJson),
      sortOrder: Value(sortOrder),
    );
  }

  factory LocalTheoryEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalTheoryEntry(
      id: serializer.fromJson<String>(json['id']),
      phase: serializer.fromJson<String>(json['phase']),
      title: serializer.fromJson<String>(json['title']),
      subtitle: serializer.fromJson<String?>(json['subtitle']),
      summary: serializer.fromJson<String>(json['summary']),
      movesJson: serializer.fromJson<String>(json['movesJson']),
      keyIdeasJson: serializer.fromJson<String>(json['keyIdeasJson']),
      variationsJson: serializer.fromJson<String>(json['variationsJson']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      tagsJson: serializer.fromJson<String>(json['tagsJson']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'phase': serializer.toJson<String>(phase),
      'title': serializer.toJson<String>(title),
      'subtitle': serializer.toJson<String?>(subtitle),
      'summary': serializer.toJson<String>(summary),
      'movesJson': serializer.toJson<String>(movesJson),
      'keyIdeasJson': serializer.toJson<String>(keyIdeasJson),
      'variationsJson': serializer.toJson<String>(variationsJson),
      'difficulty': serializer.toJson<String>(difficulty),
      'tagsJson': serializer.toJson<String>(tagsJson),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  LocalTheoryEntry copyWith(
          {String? id,
          String? phase,
          String? title,
          Value<String?> subtitle = const Value.absent(),
          String? summary,
          String? movesJson,
          String? keyIdeasJson,
          String? variationsJson,
          String? difficulty,
          String? tagsJson,
          int? sortOrder}) =>
      LocalTheoryEntry(
        id: id ?? this.id,
        phase: phase ?? this.phase,
        title: title ?? this.title,
        subtitle: subtitle.present ? subtitle.value : this.subtitle,
        summary: summary ?? this.summary,
        movesJson: movesJson ?? this.movesJson,
        keyIdeasJson: keyIdeasJson ?? this.keyIdeasJson,
        variationsJson: variationsJson ?? this.variationsJson,
        difficulty: difficulty ?? this.difficulty,
        tagsJson: tagsJson ?? this.tagsJson,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  LocalTheoryEntry copyWithCompanion(TheoryEntriesCompanion data) {
    return LocalTheoryEntry(
      id: data.id.present ? data.id.value : this.id,
      phase: data.phase.present ? data.phase.value : this.phase,
      title: data.title.present ? data.title.value : this.title,
      subtitle: data.subtitle.present ? data.subtitle.value : this.subtitle,
      summary: data.summary.present ? data.summary.value : this.summary,
      movesJson: data.movesJson.present ? data.movesJson.value : this.movesJson,
      keyIdeasJson: data.keyIdeasJson.present
          ? data.keyIdeasJson.value
          : this.keyIdeasJson,
      variationsJson: data.variationsJson.present
          ? data.variationsJson.value
          : this.variationsJson,
      difficulty:
          data.difficulty.present ? data.difficulty.value : this.difficulty,
      tagsJson: data.tagsJson.present ? data.tagsJson.value : this.tagsJson,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalTheoryEntry(')
          ..write('id: $id, ')
          ..write('phase: $phase, ')
          ..write('title: $title, ')
          ..write('subtitle: $subtitle, ')
          ..write('summary: $summary, ')
          ..write('movesJson: $movesJson, ')
          ..write('keyIdeasJson: $keyIdeasJson, ')
          ..write('variationsJson: $variationsJson, ')
          ..write('difficulty: $difficulty, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, phase, title, subtitle, summary,
      movesJson, keyIdeasJson, variationsJson, difficulty, tagsJson, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalTheoryEntry &&
          other.id == this.id &&
          other.phase == this.phase &&
          other.title == this.title &&
          other.subtitle == this.subtitle &&
          other.summary == this.summary &&
          other.movesJson == this.movesJson &&
          other.keyIdeasJson == this.keyIdeasJson &&
          other.variationsJson == this.variationsJson &&
          other.difficulty == this.difficulty &&
          other.tagsJson == this.tagsJson &&
          other.sortOrder == this.sortOrder);
}

class TheoryEntriesCompanion extends UpdateCompanion<LocalTheoryEntry> {
  final Value<String> id;
  final Value<String> phase;
  final Value<String> title;
  final Value<String?> subtitle;
  final Value<String> summary;
  final Value<String> movesJson;
  final Value<String> keyIdeasJson;
  final Value<String> variationsJson;
  final Value<String> difficulty;
  final Value<String> tagsJson;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const TheoryEntriesCompanion({
    this.id = const Value.absent(),
    this.phase = const Value.absent(),
    this.title = const Value.absent(),
    this.subtitle = const Value.absent(),
    this.summary = const Value.absent(),
    this.movesJson = const Value.absent(),
    this.keyIdeasJson = const Value.absent(),
    this.variationsJson = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TheoryEntriesCompanion.insert({
    required String id,
    required String phase,
    required String title,
    this.subtitle = const Value.absent(),
    required String summary,
    required String movesJson,
    required String keyIdeasJson,
    required String variationsJson,
    required String difficulty,
    required String tagsJson,
    required int sortOrder,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        phase = Value(phase),
        title = Value(title),
        summary = Value(summary),
        movesJson = Value(movesJson),
        keyIdeasJson = Value(keyIdeasJson),
        variationsJson = Value(variationsJson),
        difficulty = Value(difficulty),
        tagsJson = Value(tagsJson),
        sortOrder = Value(sortOrder);
  static Insertable<LocalTheoryEntry> custom({
    Expression<String>? id,
    Expression<String>? phase,
    Expression<String>? title,
    Expression<String>? subtitle,
    Expression<String>? summary,
    Expression<String>? movesJson,
    Expression<String>? keyIdeasJson,
    Expression<String>? variationsJson,
    Expression<String>? difficulty,
    Expression<String>? tagsJson,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (phase != null) 'phase': phase,
      if (title != null) 'title': title,
      if (subtitle != null) 'subtitle': subtitle,
      if (summary != null) 'summary': summary,
      if (movesJson != null) 'moves_json': movesJson,
      if (keyIdeasJson != null) 'key_ideas_json': keyIdeasJson,
      if (variationsJson != null) 'variations_json': variationsJson,
      if (difficulty != null) 'difficulty': difficulty,
      if (tagsJson != null) 'tags_json': tagsJson,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TheoryEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? phase,
      Value<String>? title,
      Value<String?>? subtitle,
      Value<String>? summary,
      Value<String>? movesJson,
      Value<String>? keyIdeasJson,
      Value<String>? variationsJson,
      Value<String>? difficulty,
      Value<String>? tagsJson,
      Value<int>? sortOrder,
      Value<int>? rowid}) {
    return TheoryEntriesCompanion(
      id: id ?? this.id,
      phase: phase ?? this.phase,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      summary: summary ?? this.summary,
      movesJson: movesJson ?? this.movesJson,
      keyIdeasJson: keyIdeasJson ?? this.keyIdeasJson,
      variationsJson: variationsJson ?? this.variationsJson,
      difficulty: difficulty ?? this.difficulty,
      tagsJson: tagsJson ?? this.tagsJson,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (phase.present) {
      map['phase'] = Variable<String>(phase.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (subtitle.present) {
      map['subtitle'] = Variable<String>(subtitle.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (movesJson.present) {
      map['moves_json'] = Variable<String>(movesJson.value);
    }
    if (keyIdeasJson.present) {
      map['key_ideas_json'] = Variable<String>(keyIdeasJson.value);
    }
    if (variationsJson.present) {
      map['variations_json'] = Variable<String>(variationsJson.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TheoryEntriesCompanion(')
          ..write('id: $id, ')
          ..write('phase: $phase, ')
          ..write('title: $title, ')
          ..write('subtitle: $subtitle, ')
          ..write('summary: $summary, ')
          ..write('movesJson: $movesJson, ')
          ..write('keyIdeasJson: $keyIdeasJson, ')
          ..write('variationsJson: $variationsJson, ')
          ..write('difficulty: $difficulty, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TheoryUserDataTable extends TheoryUserData
    with TableInfo<$TheoryUserDataTable, LocalTheoryUserData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TheoryUserDataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _theoryIdMeta =
      const VerificationMeta('theoryId');
  @override
  late final GeneratedColumn<String> theoryId = GeneratedColumn<String>(
      'theory_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isBookmarkedMeta =
      const VerificationMeta('isBookmarked');
  @override
  late final GeneratedColumn<bool> isBookmarked = GeneratedColumn<bool>(
      'is_bookmarked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_bookmarked" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [theoryId, isBookmarked, isCompleted, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'theory_user_data';
  @override
  VerificationContext validateIntegrity(
      Insertable<LocalTheoryUserData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('theory_id')) {
      context.handle(_theoryIdMeta,
          theoryId.isAcceptableOrUnknown(data['theory_id']!, _theoryIdMeta));
    } else if (isInserting) {
      context.missing(_theoryIdMeta);
    }
    if (data.containsKey('is_bookmarked')) {
      context.handle(
          _isBookmarkedMeta,
          isBookmarked.isAcceptableOrUnknown(
              data['is_bookmarked']!, _isBookmarkedMeta));
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {theoryId};
  @override
  LocalTheoryUserData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalTheoryUserData(
      theoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}theory_id'])!,
      isBookmarked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_bookmarked'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TheoryUserDataTable createAlias(String alias) {
    return $TheoryUserDataTable(attachedDatabase, alias);
  }
}

class LocalTheoryUserData extends DataClass
    implements Insertable<LocalTheoryUserData> {
  final String theoryId;
  final bool isBookmarked;
  final bool isCompleted;
  final DateTime updatedAt;
  const LocalTheoryUserData(
      {required this.theoryId,
      required this.isBookmarked,
      required this.isCompleted,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['theory_id'] = Variable<String>(theoryId);
    map['is_bookmarked'] = Variable<bool>(isBookmarked);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TheoryUserDataCompanion toCompanion(bool nullToAbsent) {
    return TheoryUserDataCompanion(
      theoryId: Value(theoryId),
      isBookmarked: Value(isBookmarked),
      isCompleted: Value(isCompleted),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalTheoryUserData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalTheoryUserData(
      theoryId: serializer.fromJson<String>(json['theoryId']),
      isBookmarked: serializer.fromJson<bool>(json['isBookmarked']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'theoryId': serializer.toJson<String>(theoryId),
      'isBookmarked': serializer.toJson<bool>(isBookmarked),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalTheoryUserData copyWith(
          {String? theoryId,
          bool? isBookmarked,
          bool? isCompleted,
          DateTime? updatedAt}) =>
      LocalTheoryUserData(
        theoryId: theoryId ?? this.theoryId,
        isBookmarked: isBookmarked ?? this.isBookmarked,
        isCompleted: isCompleted ?? this.isCompleted,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  LocalTheoryUserData copyWithCompanion(TheoryUserDataCompanion data) {
    return LocalTheoryUserData(
      theoryId: data.theoryId.present ? data.theoryId.value : this.theoryId,
      isBookmarked: data.isBookmarked.present
          ? data.isBookmarked.value
          : this.isBookmarked,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalTheoryUserData(')
          ..write('theoryId: $theoryId, ')
          ..write('isBookmarked: $isBookmarked, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(theoryId, isBookmarked, isCompleted, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalTheoryUserData &&
          other.theoryId == this.theoryId &&
          other.isBookmarked == this.isBookmarked &&
          other.isCompleted == this.isCompleted &&
          other.updatedAt == this.updatedAt);
}

class TheoryUserDataCompanion extends UpdateCompanion<LocalTheoryUserData> {
  final Value<String> theoryId;
  final Value<bool> isBookmarked;
  final Value<bool> isCompleted;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TheoryUserDataCompanion({
    this.theoryId = const Value.absent(),
    this.isBookmarked = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TheoryUserDataCompanion.insert({
    required String theoryId,
    this.isBookmarked = const Value.absent(),
    this.isCompleted = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : theoryId = Value(theoryId),
        updatedAt = Value(updatedAt);
  static Insertable<LocalTheoryUserData> custom({
    Expression<String>? theoryId,
    Expression<bool>? isBookmarked,
    Expression<bool>? isCompleted,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (theoryId != null) 'theory_id': theoryId,
      if (isBookmarked != null) 'is_bookmarked': isBookmarked,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TheoryUserDataCompanion copyWith(
      {Value<String>? theoryId,
      Value<bool>? isBookmarked,
      Value<bool>? isCompleted,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return TheoryUserDataCompanion(
      theoryId: theoryId ?? this.theoryId,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isCompleted: isCompleted ?? this.isCompleted,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (theoryId.present) {
      map['theory_id'] = Variable<String>(theoryId.value);
    }
    if (isBookmarked.present) {
      map['is_bookmarked'] = Variable<bool>(isBookmarked.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TheoryUserDataCompanion(')
          ..write('theoryId: $theoryId, ')
          ..write('isBookmarked: $isBookmarked, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HistoricalMatchesTable extends HistoricalMatches
    with TableInfo<$HistoricalMatchesTable, LocalHistoricalMatch> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistoricalMatchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _whitePlayerMeta =
      const VerificationMeta('whitePlayer');
  @override
  late final GeneratedColumn<String> whitePlayer = GeneratedColumn<String>(
      'white_player', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _blackPlayerMeta =
      const VerificationMeta('blackPlayer');
  @override
  late final GeneratedColumn<String> blackPlayer = GeneratedColumn<String>(
      'black_player', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _eventMeta = const VerificationMeta('event');
  @override
  late final GeneratedColumn<String> event = GeneratedColumn<String>(
      'event', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _resultMeta = const VerificationMeta('result');
  @override
  late final GeneratedColumn<String> result = GeneratedColumn<String>(
      'result', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pgnMeta = const VerificationMeta('pgn');
  @override
  late final GeneratedColumn<String> pgn = GeneratedColumn<String>(
      'pgn', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tagsJsonMeta =
      const VerificationMeta('tagsJson');
  @override
  late final GeneratedColumn<String> tagsJson = GeneratedColumn<String>(
      'tags_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _difficultyMeta =
      const VerificationMeta('difficulty');
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
      'difficulty', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        whitePlayer,
        blackPlayer,
        event,
        year,
        result,
        pgn,
        description,
        tagsJson,
        difficulty,
        sortOrder
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'historical_matches';
  @override
  VerificationContext validateIntegrity(
      Insertable<LocalHistoricalMatch> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('white_player')) {
      context.handle(
          _whitePlayerMeta,
          whitePlayer.isAcceptableOrUnknown(
              data['white_player']!, _whitePlayerMeta));
    } else if (isInserting) {
      context.missing(_whitePlayerMeta);
    }
    if (data.containsKey('black_player')) {
      context.handle(
          _blackPlayerMeta,
          blackPlayer.isAcceptableOrUnknown(
              data['black_player']!, _blackPlayerMeta));
    } else if (isInserting) {
      context.missing(_blackPlayerMeta);
    }
    if (data.containsKey('event')) {
      context.handle(
          _eventMeta, event.isAcceptableOrUnknown(data['event']!, _eventMeta));
    } else if (isInserting) {
      context.missing(_eventMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('result')) {
      context.handle(_resultMeta,
          result.isAcceptableOrUnknown(data['result']!, _resultMeta));
    } else if (isInserting) {
      context.missing(_resultMeta);
    }
    if (data.containsKey('pgn')) {
      context.handle(
          _pgnMeta, pgn.isAcceptableOrUnknown(data['pgn']!, _pgnMeta));
    } else if (isInserting) {
      context.missing(_pgnMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('tags_json')) {
      context.handle(_tagsJsonMeta,
          tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta));
    } else if (isInserting) {
      context.missing(_tagsJsonMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
          _difficultyMeta,
          difficulty.isAcceptableOrUnknown(
              data['difficulty']!, _difficultyMeta));
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalHistoricalMatch map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalHistoricalMatch(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      whitePlayer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}white_player'])!,
      blackPlayer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}black_player'])!,
      event: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event'])!,
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year'])!,
      result: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}result'])!,
      pgn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pgn'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      tagsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags_json'])!,
      difficulty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}difficulty'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $HistoricalMatchesTable createAlias(String alias) {
    return $HistoricalMatchesTable(attachedDatabase, alias);
  }
}

class LocalHistoricalMatch extends DataClass
    implements Insertable<LocalHistoricalMatch> {
  final String id;
  final String whitePlayer;
  final String blackPlayer;
  final String event;
  final int year;
  final String result;
  final String pgn;
  final String description;
  final String tagsJson;
  final String difficulty;
  final int sortOrder;
  const LocalHistoricalMatch(
      {required this.id,
      required this.whitePlayer,
      required this.blackPlayer,
      required this.event,
      required this.year,
      required this.result,
      required this.pgn,
      required this.description,
      required this.tagsJson,
      required this.difficulty,
      required this.sortOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['white_player'] = Variable<String>(whitePlayer);
    map['black_player'] = Variable<String>(blackPlayer);
    map['event'] = Variable<String>(event);
    map['year'] = Variable<int>(year);
    map['result'] = Variable<String>(result);
    map['pgn'] = Variable<String>(pgn);
    map['description'] = Variable<String>(description);
    map['tags_json'] = Variable<String>(tagsJson);
    map['difficulty'] = Variable<String>(difficulty);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  HistoricalMatchesCompanion toCompanion(bool nullToAbsent) {
    return HistoricalMatchesCompanion(
      id: Value(id),
      whitePlayer: Value(whitePlayer),
      blackPlayer: Value(blackPlayer),
      event: Value(event),
      year: Value(year),
      result: Value(result),
      pgn: Value(pgn),
      description: Value(description),
      tagsJson: Value(tagsJson),
      difficulty: Value(difficulty),
      sortOrder: Value(sortOrder),
    );
  }

  factory LocalHistoricalMatch.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalHistoricalMatch(
      id: serializer.fromJson<String>(json['id']),
      whitePlayer: serializer.fromJson<String>(json['whitePlayer']),
      blackPlayer: serializer.fromJson<String>(json['blackPlayer']),
      event: serializer.fromJson<String>(json['event']),
      year: serializer.fromJson<int>(json['year']),
      result: serializer.fromJson<String>(json['result']),
      pgn: serializer.fromJson<String>(json['pgn']),
      description: serializer.fromJson<String>(json['description']),
      tagsJson: serializer.fromJson<String>(json['tagsJson']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'whitePlayer': serializer.toJson<String>(whitePlayer),
      'blackPlayer': serializer.toJson<String>(blackPlayer),
      'event': serializer.toJson<String>(event),
      'year': serializer.toJson<int>(year),
      'result': serializer.toJson<String>(result),
      'pgn': serializer.toJson<String>(pgn),
      'description': serializer.toJson<String>(description),
      'tagsJson': serializer.toJson<String>(tagsJson),
      'difficulty': serializer.toJson<String>(difficulty),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  LocalHistoricalMatch copyWith(
          {String? id,
          String? whitePlayer,
          String? blackPlayer,
          String? event,
          int? year,
          String? result,
          String? pgn,
          String? description,
          String? tagsJson,
          String? difficulty,
          int? sortOrder}) =>
      LocalHistoricalMatch(
        id: id ?? this.id,
        whitePlayer: whitePlayer ?? this.whitePlayer,
        blackPlayer: blackPlayer ?? this.blackPlayer,
        event: event ?? this.event,
        year: year ?? this.year,
        result: result ?? this.result,
        pgn: pgn ?? this.pgn,
        description: description ?? this.description,
        tagsJson: tagsJson ?? this.tagsJson,
        difficulty: difficulty ?? this.difficulty,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  LocalHistoricalMatch copyWithCompanion(HistoricalMatchesCompanion data) {
    return LocalHistoricalMatch(
      id: data.id.present ? data.id.value : this.id,
      whitePlayer:
          data.whitePlayer.present ? data.whitePlayer.value : this.whitePlayer,
      blackPlayer:
          data.blackPlayer.present ? data.blackPlayer.value : this.blackPlayer,
      event: data.event.present ? data.event.value : this.event,
      year: data.year.present ? data.year.value : this.year,
      result: data.result.present ? data.result.value : this.result,
      pgn: data.pgn.present ? data.pgn.value : this.pgn,
      description:
          data.description.present ? data.description.value : this.description,
      tagsJson: data.tagsJson.present ? data.tagsJson.value : this.tagsJson,
      difficulty:
          data.difficulty.present ? data.difficulty.value : this.difficulty,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalHistoricalMatch(')
          ..write('id: $id, ')
          ..write('whitePlayer: $whitePlayer, ')
          ..write('blackPlayer: $blackPlayer, ')
          ..write('event: $event, ')
          ..write('year: $year, ')
          ..write('result: $result, ')
          ..write('pgn: $pgn, ')
          ..write('description: $description, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('difficulty: $difficulty, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, whitePlayer, blackPlayer, event, year,
      result, pgn, description, tagsJson, difficulty, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalHistoricalMatch &&
          other.id == this.id &&
          other.whitePlayer == this.whitePlayer &&
          other.blackPlayer == this.blackPlayer &&
          other.event == this.event &&
          other.year == this.year &&
          other.result == this.result &&
          other.pgn == this.pgn &&
          other.description == this.description &&
          other.tagsJson == this.tagsJson &&
          other.difficulty == this.difficulty &&
          other.sortOrder == this.sortOrder);
}

class HistoricalMatchesCompanion extends UpdateCompanion<LocalHistoricalMatch> {
  final Value<String> id;
  final Value<String> whitePlayer;
  final Value<String> blackPlayer;
  final Value<String> event;
  final Value<int> year;
  final Value<String> result;
  final Value<String> pgn;
  final Value<String> description;
  final Value<String> tagsJson;
  final Value<String> difficulty;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const HistoricalMatchesCompanion({
    this.id = const Value.absent(),
    this.whitePlayer = const Value.absent(),
    this.blackPlayer = const Value.absent(),
    this.event = const Value.absent(),
    this.year = const Value.absent(),
    this.result = const Value.absent(),
    this.pgn = const Value.absent(),
    this.description = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HistoricalMatchesCompanion.insert({
    required String id,
    required String whitePlayer,
    required String blackPlayer,
    required String event,
    required int year,
    required String result,
    required String pgn,
    required String description,
    required String tagsJson,
    required String difficulty,
    required int sortOrder,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        whitePlayer = Value(whitePlayer),
        blackPlayer = Value(blackPlayer),
        event = Value(event),
        year = Value(year),
        result = Value(result),
        pgn = Value(pgn),
        description = Value(description),
        tagsJson = Value(tagsJson),
        difficulty = Value(difficulty),
        sortOrder = Value(sortOrder);
  static Insertable<LocalHistoricalMatch> custom({
    Expression<String>? id,
    Expression<String>? whitePlayer,
    Expression<String>? blackPlayer,
    Expression<String>? event,
    Expression<int>? year,
    Expression<String>? result,
    Expression<String>? pgn,
    Expression<String>? description,
    Expression<String>? tagsJson,
    Expression<String>? difficulty,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (whitePlayer != null) 'white_player': whitePlayer,
      if (blackPlayer != null) 'black_player': blackPlayer,
      if (event != null) 'event': event,
      if (year != null) 'year': year,
      if (result != null) 'result': result,
      if (pgn != null) 'pgn': pgn,
      if (description != null) 'description': description,
      if (tagsJson != null) 'tags_json': tagsJson,
      if (difficulty != null) 'difficulty': difficulty,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HistoricalMatchesCompanion copyWith(
      {Value<String>? id,
      Value<String>? whitePlayer,
      Value<String>? blackPlayer,
      Value<String>? event,
      Value<int>? year,
      Value<String>? result,
      Value<String>? pgn,
      Value<String>? description,
      Value<String>? tagsJson,
      Value<String>? difficulty,
      Value<int>? sortOrder,
      Value<int>? rowid}) {
    return HistoricalMatchesCompanion(
      id: id ?? this.id,
      whitePlayer: whitePlayer ?? this.whitePlayer,
      blackPlayer: blackPlayer ?? this.blackPlayer,
      event: event ?? this.event,
      year: year ?? this.year,
      result: result ?? this.result,
      pgn: pgn ?? this.pgn,
      description: description ?? this.description,
      tagsJson: tagsJson ?? this.tagsJson,
      difficulty: difficulty ?? this.difficulty,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (whitePlayer.present) {
      map['white_player'] = Variable<String>(whitePlayer.value);
    }
    if (blackPlayer.present) {
      map['black_player'] = Variable<String>(blackPlayer.value);
    }
    if (event.present) {
      map['event'] = Variable<String>(event.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (result.present) {
      map['result'] = Variable<String>(result.value);
    }
    if (pgn.present) {
      map['pgn'] = Variable<String>(pgn.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistoricalMatchesCompanion(')
          ..write('id: $id, ')
          ..write('whitePlayer: $whitePlayer, ')
          ..write('blackPlayer: $blackPlayer, ')
          ..write('event: $event, ')
          ..write('year: $year, ')
          ..write('result: $result, ')
          ..write('pgn: $pgn, ')
          ..write('description: $description, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('difficulty: $difficulty, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GamesTable games = $GamesTable(this);
  late final $MovesTable moves = $MovesTable(this);
  late final $ProfileTable profile = $ProfileTable(this);
  late final $CacheMetaTable cacheMeta = $CacheMetaTable(this);
  late final $TheoryEntriesTable theoryEntries = $TheoryEntriesTable(this);
  late final $TheoryUserDataTable theoryUserData = $TheoryUserDataTable(this);
  late final $HistoricalMatchesTable historicalMatches =
      $HistoricalMatchesTable(this);
  late final TheoryDao theoryDao = TheoryDao(this as AppDatabase);
  late final HistoricalMatchesDao historicalMatchesDao =
      HistoricalMatchesDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        games,
        moves,
        profile,
        cacheMeta,
        theoryEntries,
        theoryUserData,
        historicalMatches
      ];
}

typedef $$GamesTableCreateCompanionBuilder = GamesCompanion Function({
  Value<int> id,
  required String pgn,
  required String result,
  required String mode,
  Value<int?> botLevel,
  Value<int?> timeControlSeconds,
  required DateTime playedAt,
  Value<int?> playerAccuracy,
  Value<int> playerColorIndex,
  Value<String?> remoteId,
  Value<bool> pendingSync,
  Value<String> fen,
  Value<bool> isActive,
});
typedef $$GamesTableUpdateCompanionBuilder = GamesCompanion Function({
  Value<int> id,
  Value<String> pgn,
  Value<String> result,
  Value<String> mode,
  Value<int?> botLevel,
  Value<int?> timeControlSeconds,
  Value<DateTime> playedAt,
  Value<int?> playerAccuracy,
  Value<int> playerColorIndex,
  Value<String?> remoteId,
  Value<bool> pendingSync,
  Value<String> fen,
  Value<bool> isActive,
});

final class $$GamesTableReferences
    extends BaseReferences<_$AppDatabase, $GamesTable, Game> {
  $$GamesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MovesTable, List<Move>> _movesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.moves,
          aliasName: $_aliasNameGenerator(db.games.id, db.moves.gameId));

  $$MovesTableProcessedTableManager get movesRefs {
    final manager = $$MovesTableTableManager($_db, $_db.moves)
        .filter((f) => f.gameId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_movesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$GamesTableFilterComposer extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pgn => $composableBuilder(
      column: $table.pgn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get result => $composableBuilder(
      column: $table.result, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mode => $composableBuilder(
      column: $table.mode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get botLevel => $composableBuilder(
      column: $table.botLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get timeControlSeconds => $composableBuilder(
      column: $table.timeControlSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get playedAt => $composableBuilder(
      column: $table.playedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get playerAccuracy => $composableBuilder(
      column: $table.playerAccuracy,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get playerColorIndex => $composableBuilder(
      column: $table.playerColorIndex,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get pendingSync => $composableBuilder(
      column: $table.pendingSync, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fen => $composableBuilder(
      column: $table.fen, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  Expression<bool> movesRefs(
      Expression<bool> Function($$MovesTableFilterComposer f) f) {
    final $$MovesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.moves,
        getReferencedColumn: (t) => t.gameId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MovesTableFilterComposer(
              $db: $db,
              $table: $db.moves,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GamesTableOrderingComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pgn => $composableBuilder(
      column: $table.pgn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get result => $composableBuilder(
      column: $table.result, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mode => $composableBuilder(
      column: $table.mode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get botLevel => $composableBuilder(
      column: $table.botLevel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get timeControlSeconds => $composableBuilder(
      column: $table.timeControlSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get playedAt => $composableBuilder(
      column: $table.playedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get playerAccuracy => $composableBuilder(
      column: $table.playerAccuracy,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get playerColorIndex => $composableBuilder(
      column: $table.playerColorIndex,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get pendingSync => $composableBuilder(
      column: $table.pendingSync, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fen => $composableBuilder(
      column: $table.fen, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$GamesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get pgn =>
      $composableBuilder(column: $table.pgn, builder: (column) => column);

  GeneratedColumn<String> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<int> get botLevel =>
      $composableBuilder(column: $table.botLevel, builder: (column) => column);

  GeneratedColumn<int> get timeControlSeconds => $composableBuilder(
      column: $table.timeControlSeconds, builder: (column) => column);

  GeneratedColumn<DateTime> get playedAt =>
      $composableBuilder(column: $table.playedAt, builder: (column) => column);

  GeneratedColumn<int> get playerAccuracy => $composableBuilder(
      column: $table.playerAccuracy, builder: (column) => column);

  GeneratedColumn<int> get playerColorIndex => $composableBuilder(
      column: $table.playerColorIndex, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<bool> get pendingSync => $composableBuilder(
      column: $table.pendingSync, builder: (column) => column);

  GeneratedColumn<String> get fen =>
      $composableBuilder(column: $table.fen, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> movesRefs<T extends Object>(
      Expression<T> Function($$MovesTableAnnotationComposer a) f) {
    final $$MovesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.moves,
        getReferencedColumn: (t) => t.gameId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MovesTableAnnotationComposer(
              $db: $db,
              $table: $db.moves,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GamesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GamesTable,
    Game,
    $$GamesTableFilterComposer,
    $$GamesTableOrderingComposer,
    $$GamesTableAnnotationComposer,
    $$GamesTableCreateCompanionBuilder,
    $$GamesTableUpdateCompanionBuilder,
    (Game, $$GamesTableReferences),
    Game,
    PrefetchHooks Function({bool movesRefs})> {
  $$GamesTableTableManager(_$AppDatabase db, $GamesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> pgn = const Value.absent(),
            Value<String> result = const Value.absent(),
            Value<String> mode = const Value.absent(),
            Value<int?> botLevel = const Value.absent(),
            Value<int?> timeControlSeconds = const Value.absent(),
            Value<DateTime> playedAt = const Value.absent(),
            Value<int?> playerAccuracy = const Value.absent(),
            Value<int> playerColorIndex = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> pendingSync = const Value.absent(),
            Value<String> fen = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              GamesCompanion(
            id: id,
            pgn: pgn,
            result: result,
            mode: mode,
            botLevel: botLevel,
            timeControlSeconds: timeControlSeconds,
            playedAt: playedAt,
            playerAccuracy: playerAccuracy,
            playerColorIndex: playerColorIndex,
            remoteId: remoteId,
            pendingSync: pendingSync,
            fen: fen,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String pgn,
            required String result,
            required String mode,
            Value<int?> botLevel = const Value.absent(),
            Value<int?> timeControlSeconds = const Value.absent(),
            required DateTime playedAt,
            Value<int?> playerAccuracy = const Value.absent(),
            Value<int> playerColorIndex = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> pendingSync = const Value.absent(),
            Value<String> fen = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              GamesCompanion.insert(
            id: id,
            pgn: pgn,
            result: result,
            mode: mode,
            botLevel: botLevel,
            timeControlSeconds: timeControlSeconds,
            playedAt: playedAt,
            playerAccuracy: playerAccuracy,
            playerColorIndex: playerColorIndex,
            remoteId: remoteId,
            pendingSync: pendingSync,
            fen: fen,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$GamesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({movesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (movesRefs) db.moves],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (movesRefs)
                    await $_getPrefetchedData<Game, $GamesTable, Move>(
                        currentTable: table,
                        referencedTable:
                            $$GamesTableReferences._movesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GamesTableReferences(db, table, p0).movesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.gameId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$GamesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GamesTable,
    Game,
    $$GamesTableFilterComposer,
    $$GamesTableOrderingComposer,
    $$GamesTableAnnotationComposer,
    $$GamesTableCreateCompanionBuilder,
    $$GamesTableUpdateCompanionBuilder,
    (Game, $$GamesTableReferences),
    Game,
    PrefetchHooks Function({bool movesRefs})>;
typedef $$MovesTableCreateCompanionBuilder = MovesCompanion Function({
  Value<int> id,
  required int gameId,
  required int ply,
  required String uci,
  required String san,
  Value<int?> evalCentipawns,
  Value<String?> classification,
  Value<String?> bestMoveUci,
});
typedef $$MovesTableUpdateCompanionBuilder = MovesCompanion Function({
  Value<int> id,
  Value<int> gameId,
  Value<int> ply,
  Value<String> uci,
  Value<String> san,
  Value<int?> evalCentipawns,
  Value<String?> classification,
  Value<String?> bestMoveUci,
});

final class $$MovesTableReferences
    extends BaseReferences<_$AppDatabase, $MovesTable, Move> {
  $$MovesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GamesTable _gameIdTable(_$AppDatabase db) =>
      db.games.createAlias($_aliasNameGenerator(db.moves.gameId, db.games.id));

  $$GamesTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<int>('game_id')!;

    final manager = $$GamesTableTableManager($_db, $_db.games)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MovesTableFilterComposer extends Composer<_$AppDatabase, $MovesTable> {
  $$MovesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ply => $composableBuilder(
      column: $table.ply, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uci => $composableBuilder(
      column: $table.uci, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get san => $composableBuilder(
      column: $table.san, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get evalCentipawns => $composableBuilder(
      column: $table.evalCentipawns,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get classification => $composableBuilder(
      column: $table.classification,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bestMoveUci => $composableBuilder(
      column: $table.bestMoveUci, builder: (column) => ColumnFilters(column));

  $$GamesTableFilterComposer get gameId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gameId,
        referencedTable: $db.games,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GamesTableFilterComposer(
              $db: $db,
              $table: $db.games,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MovesTableOrderingComposer
    extends Composer<_$AppDatabase, $MovesTable> {
  $$MovesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ply => $composableBuilder(
      column: $table.ply, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uci => $composableBuilder(
      column: $table.uci, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get san => $composableBuilder(
      column: $table.san, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get evalCentipawns => $composableBuilder(
      column: $table.evalCentipawns,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get classification => $composableBuilder(
      column: $table.classification,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bestMoveUci => $composableBuilder(
      column: $table.bestMoveUci, builder: (column) => ColumnOrderings(column));

  $$GamesTableOrderingComposer get gameId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gameId,
        referencedTable: $db.games,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GamesTableOrderingComposer(
              $db: $db,
              $table: $db.games,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MovesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MovesTable> {
  $$MovesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get ply =>
      $composableBuilder(column: $table.ply, builder: (column) => column);

  GeneratedColumn<String> get uci =>
      $composableBuilder(column: $table.uci, builder: (column) => column);

  GeneratedColumn<String> get san =>
      $composableBuilder(column: $table.san, builder: (column) => column);

  GeneratedColumn<int> get evalCentipawns => $composableBuilder(
      column: $table.evalCentipawns, builder: (column) => column);

  GeneratedColumn<String> get classification => $composableBuilder(
      column: $table.classification, builder: (column) => column);

  GeneratedColumn<String> get bestMoveUci => $composableBuilder(
      column: $table.bestMoveUci, builder: (column) => column);

  $$GamesTableAnnotationComposer get gameId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gameId,
        referencedTable: $db.games,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GamesTableAnnotationComposer(
              $db: $db,
              $table: $db.games,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MovesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MovesTable,
    Move,
    $$MovesTableFilterComposer,
    $$MovesTableOrderingComposer,
    $$MovesTableAnnotationComposer,
    $$MovesTableCreateCompanionBuilder,
    $$MovesTableUpdateCompanionBuilder,
    (Move, $$MovesTableReferences),
    Move,
    PrefetchHooks Function({bool gameId})> {
  $$MovesTableTableManager(_$AppDatabase db, $MovesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MovesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MovesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MovesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> gameId = const Value.absent(),
            Value<int> ply = const Value.absent(),
            Value<String> uci = const Value.absent(),
            Value<String> san = const Value.absent(),
            Value<int?> evalCentipawns = const Value.absent(),
            Value<String?> classification = const Value.absent(),
            Value<String?> bestMoveUci = const Value.absent(),
          }) =>
              MovesCompanion(
            id: id,
            gameId: gameId,
            ply: ply,
            uci: uci,
            san: san,
            evalCentipawns: evalCentipawns,
            classification: classification,
            bestMoveUci: bestMoveUci,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int gameId,
            required int ply,
            required String uci,
            required String san,
            Value<int?> evalCentipawns = const Value.absent(),
            Value<String?> classification = const Value.absent(),
            Value<String?> bestMoveUci = const Value.absent(),
          }) =>
              MovesCompanion.insert(
            id: id,
            gameId: gameId,
            ply: ply,
            uci: uci,
            san: san,
            evalCentipawns: evalCentipawns,
            classification: classification,
            bestMoveUci: bestMoveUci,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$MovesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({gameId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (gameId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.gameId,
                    referencedTable: $$MovesTableReferences._gameIdTable(db),
                    referencedColumn:
                        $$MovesTableReferences._gameIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MovesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MovesTable,
    Move,
    $$MovesTableFilterComposer,
    $$MovesTableOrderingComposer,
    $$MovesTableAnnotationComposer,
    $$MovesTableCreateCompanionBuilder,
    $$MovesTableUpdateCompanionBuilder,
    (Move, $$MovesTableReferences),
    Move,
    PrefetchHooks Function({bool gameId})>;
typedef $$ProfileTableCreateCompanionBuilder = ProfileCompanion Function({
  Value<int> id,
  Value<String> username,
  Value<String?> avatarPath,
  Value<int> currentRating,
  Value<int> peakRating,
  Value<int> gamesPlayed,
  Value<int> wins,
  Value<int> draws,
  Value<int> losses,
  Value<String?> remoteId,
  required DateTime createdAt,
});
typedef $$ProfileTableUpdateCompanionBuilder = ProfileCompanion Function({
  Value<int> id,
  Value<String> username,
  Value<String?> avatarPath,
  Value<int> currentRating,
  Value<int> peakRating,
  Value<int> gamesPlayed,
  Value<int> wins,
  Value<int> draws,
  Value<int> losses,
  Value<String?> remoteId,
  Value<DateTime> createdAt,
});

class $$ProfileTableFilterComposer
    extends Composer<_$AppDatabase, $ProfileTable> {
  $$ProfileTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentRating => $composableBuilder(
      column: $table.currentRating, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get peakRating => $composableBuilder(
      column: $table.peakRating, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get gamesPlayed => $composableBuilder(
      column: $table.gamesPlayed, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get wins => $composableBuilder(
      column: $table.wins, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get draws => $composableBuilder(
      column: $table.draws, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get losses => $composableBuilder(
      column: $table.losses, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ProfileTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfileTable> {
  $$ProfileTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentRating => $composableBuilder(
      column: $table.currentRating,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get peakRating => $composableBuilder(
      column: $table.peakRating, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get gamesPlayed => $composableBuilder(
      column: $table.gamesPlayed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get wins => $composableBuilder(
      column: $table.wins, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get draws => $composableBuilder(
      column: $table.draws, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get losses => $composableBuilder(
      column: $table.losses, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ProfileTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfileTable> {
  $$ProfileTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => column);

  GeneratedColumn<int> get currentRating => $composableBuilder(
      column: $table.currentRating, builder: (column) => column);

  GeneratedColumn<int> get peakRating => $composableBuilder(
      column: $table.peakRating, builder: (column) => column);

  GeneratedColumn<int> get gamesPlayed => $composableBuilder(
      column: $table.gamesPlayed, builder: (column) => column);

  GeneratedColumn<int> get wins =>
      $composableBuilder(column: $table.wins, builder: (column) => column);

  GeneratedColumn<int> get draws =>
      $composableBuilder(column: $table.draws, builder: (column) => column);

  GeneratedColumn<int> get losses =>
      $composableBuilder(column: $table.losses, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ProfileTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProfileTable,
    ProfileData,
    $$ProfileTableFilterComposer,
    $$ProfileTableOrderingComposer,
    $$ProfileTableAnnotationComposer,
    $$ProfileTableCreateCompanionBuilder,
    $$ProfileTableUpdateCompanionBuilder,
    (ProfileData, BaseReferences<_$AppDatabase, $ProfileTable, ProfileData>),
    ProfileData,
    PrefetchHooks Function()> {
  $$ProfileTableTableManager(_$AppDatabase db, $ProfileTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfileTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfileTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfileTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String?> avatarPath = const Value.absent(),
            Value<int> currentRating = const Value.absent(),
            Value<int> peakRating = const Value.absent(),
            Value<int> gamesPlayed = const Value.absent(),
            Value<int> wins = const Value.absent(),
            Value<int> draws = const Value.absent(),
            Value<int> losses = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ProfileCompanion(
            id: id,
            username: username,
            avatarPath: avatarPath,
            currentRating: currentRating,
            peakRating: peakRating,
            gamesPlayed: gamesPlayed,
            wins: wins,
            draws: draws,
            losses: losses,
            remoteId: remoteId,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String?> avatarPath = const Value.absent(),
            Value<int> currentRating = const Value.absent(),
            Value<int> peakRating = const Value.absent(),
            Value<int> gamesPlayed = const Value.absent(),
            Value<int> wins = const Value.absent(),
            Value<int> draws = const Value.absent(),
            Value<int> losses = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            required DateTime createdAt,
          }) =>
              ProfileCompanion.insert(
            id: id,
            username: username,
            avatarPath: avatarPath,
            currentRating: currentRating,
            peakRating: peakRating,
            gamesPlayed: gamesPlayed,
            wins: wins,
            draws: draws,
            losses: losses,
            remoteId: remoteId,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProfileTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProfileTable,
    ProfileData,
    $$ProfileTableFilterComposer,
    $$ProfileTableOrderingComposer,
    $$ProfileTableAnnotationComposer,
    $$ProfileTableCreateCompanionBuilder,
    $$ProfileTableUpdateCompanionBuilder,
    (ProfileData, BaseReferences<_$AppDatabase, $ProfileTable, ProfileData>),
    ProfileData,
    PrefetchHooks Function()>;
typedef $$CacheMetaTableCreateCompanionBuilder = CacheMetaCompanion Function({
  required String key,
  required DateTime lastFetchedAt,
  Value<int> recordCount,
  Value<int> rowid,
});
typedef $$CacheMetaTableUpdateCompanionBuilder = CacheMetaCompanion Function({
  Value<String> key,
  Value<DateTime> lastFetchedAt,
  Value<int> recordCount,
  Value<int> rowid,
});

class $$CacheMetaTableFilterComposer
    extends Composer<_$AppDatabase, $CacheMetaTable> {
  $$CacheMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastFetchedAt => $composableBuilder(
      column: $table.lastFetchedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recordCount => $composableBuilder(
      column: $table.recordCount, builder: (column) => ColumnFilters(column));
}

class $$CacheMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $CacheMetaTable> {
  $$CacheMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastFetchedAt => $composableBuilder(
      column: $table.lastFetchedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recordCount => $composableBuilder(
      column: $table.recordCount, builder: (column) => ColumnOrderings(column));
}

class $$CacheMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $CacheMetaTable> {
  $$CacheMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<DateTime> get lastFetchedAt => $composableBuilder(
      column: $table.lastFetchedAt, builder: (column) => column);

  GeneratedColumn<int> get recordCount => $composableBuilder(
      column: $table.recordCount, builder: (column) => column);
}

class $$CacheMetaTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CacheMetaTable,
    CacheMetaData,
    $$CacheMetaTableFilterComposer,
    $$CacheMetaTableOrderingComposer,
    $$CacheMetaTableAnnotationComposer,
    $$CacheMetaTableCreateCompanionBuilder,
    $$CacheMetaTableUpdateCompanionBuilder,
    (
      CacheMetaData,
      BaseReferences<_$AppDatabase, $CacheMetaTable, CacheMetaData>
    ),
    CacheMetaData,
    PrefetchHooks Function()> {
  $$CacheMetaTableTableManager(_$AppDatabase db, $CacheMetaTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CacheMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CacheMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CacheMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<DateTime> lastFetchedAt = const Value.absent(),
            Value<int> recordCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CacheMetaCompanion(
            key: key,
            lastFetchedAt: lastFetchedAt,
            recordCount: recordCount,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required DateTime lastFetchedAt,
            Value<int> recordCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CacheMetaCompanion.insert(
            key: key,
            lastFetchedAt: lastFetchedAt,
            recordCount: recordCount,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CacheMetaTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CacheMetaTable,
    CacheMetaData,
    $$CacheMetaTableFilterComposer,
    $$CacheMetaTableOrderingComposer,
    $$CacheMetaTableAnnotationComposer,
    $$CacheMetaTableCreateCompanionBuilder,
    $$CacheMetaTableUpdateCompanionBuilder,
    (
      CacheMetaData,
      BaseReferences<_$AppDatabase, $CacheMetaTable, CacheMetaData>
    ),
    CacheMetaData,
    PrefetchHooks Function()>;
typedef $$TheoryEntriesTableCreateCompanionBuilder = TheoryEntriesCompanion
    Function({
  required String id,
  required String phase,
  required String title,
  Value<String?> subtitle,
  required String summary,
  required String movesJson,
  required String keyIdeasJson,
  required String variationsJson,
  required String difficulty,
  required String tagsJson,
  required int sortOrder,
  Value<int> rowid,
});
typedef $$TheoryEntriesTableUpdateCompanionBuilder = TheoryEntriesCompanion
    Function({
  Value<String> id,
  Value<String> phase,
  Value<String> title,
  Value<String?> subtitle,
  Value<String> summary,
  Value<String> movesJson,
  Value<String> keyIdeasJson,
  Value<String> variationsJson,
  Value<String> difficulty,
  Value<String> tagsJson,
  Value<int> sortOrder,
  Value<int> rowid,
});

class $$TheoryEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $TheoryEntriesTable> {
  $$TheoryEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phase => $composableBuilder(
      column: $table.phase, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subtitle => $composableBuilder(
      column: $table.subtitle, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get movesJson => $composableBuilder(
      column: $table.movesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get keyIdeasJson => $composableBuilder(
      column: $table.keyIdeasJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get variationsJson => $composableBuilder(
      column: $table.variationsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tagsJson => $composableBuilder(
      column: $table.tagsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));
}

class $$TheoryEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $TheoryEntriesTable> {
  $$TheoryEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phase => $composableBuilder(
      column: $table.phase, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subtitle => $composableBuilder(
      column: $table.subtitle, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get movesJson => $composableBuilder(
      column: $table.movesJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get keyIdeasJson => $composableBuilder(
      column: $table.keyIdeasJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get variationsJson => $composableBuilder(
      column: $table.variationsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tagsJson => $composableBuilder(
      column: $table.tagsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));
}

class $$TheoryEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TheoryEntriesTable> {
  $$TheoryEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get phase =>
      $composableBuilder(column: $table.phase, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get subtitle =>
      $composableBuilder(column: $table.subtitle, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get movesJson =>
      $composableBuilder(column: $table.movesJson, builder: (column) => column);

  GeneratedColumn<String> get keyIdeasJson => $composableBuilder(
      column: $table.keyIdeasJson, builder: (column) => column);

  GeneratedColumn<String> get variationsJson => $composableBuilder(
      column: $table.variationsJson, builder: (column) => column);

  GeneratedColumn<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => column);

  GeneratedColumn<String> get tagsJson =>
      $composableBuilder(column: $table.tagsJson, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$TheoryEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TheoryEntriesTable,
    LocalTheoryEntry,
    $$TheoryEntriesTableFilterComposer,
    $$TheoryEntriesTableOrderingComposer,
    $$TheoryEntriesTableAnnotationComposer,
    $$TheoryEntriesTableCreateCompanionBuilder,
    $$TheoryEntriesTableUpdateCompanionBuilder,
    (
      LocalTheoryEntry,
      BaseReferences<_$AppDatabase, $TheoryEntriesTable, LocalTheoryEntry>
    ),
    LocalTheoryEntry,
    PrefetchHooks Function()> {
  $$TheoryEntriesTableTableManager(_$AppDatabase db, $TheoryEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TheoryEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TheoryEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TheoryEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> phase = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> subtitle = const Value.absent(),
            Value<String> summary = const Value.absent(),
            Value<String> movesJson = const Value.absent(),
            Value<String> keyIdeasJson = const Value.absent(),
            Value<String> variationsJson = const Value.absent(),
            Value<String> difficulty = const Value.absent(),
            Value<String> tagsJson = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TheoryEntriesCompanion(
            id: id,
            phase: phase,
            title: title,
            subtitle: subtitle,
            summary: summary,
            movesJson: movesJson,
            keyIdeasJson: keyIdeasJson,
            variationsJson: variationsJson,
            difficulty: difficulty,
            tagsJson: tagsJson,
            sortOrder: sortOrder,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String phase,
            required String title,
            Value<String?> subtitle = const Value.absent(),
            required String summary,
            required String movesJson,
            required String keyIdeasJson,
            required String variationsJson,
            required String difficulty,
            required String tagsJson,
            required int sortOrder,
            Value<int> rowid = const Value.absent(),
          }) =>
              TheoryEntriesCompanion.insert(
            id: id,
            phase: phase,
            title: title,
            subtitle: subtitle,
            summary: summary,
            movesJson: movesJson,
            keyIdeasJson: keyIdeasJson,
            variationsJson: variationsJson,
            difficulty: difficulty,
            tagsJson: tagsJson,
            sortOrder: sortOrder,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TheoryEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TheoryEntriesTable,
    LocalTheoryEntry,
    $$TheoryEntriesTableFilterComposer,
    $$TheoryEntriesTableOrderingComposer,
    $$TheoryEntriesTableAnnotationComposer,
    $$TheoryEntriesTableCreateCompanionBuilder,
    $$TheoryEntriesTableUpdateCompanionBuilder,
    (
      LocalTheoryEntry,
      BaseReferences<_$AppDatabase, $TheoryEntriesTable, LocalTheoryEntry>
    ),
    LocalTheoryEntry,
    PrefetchHooks Function()>;
typedef $$TheoryUserDataTableCreateCompanionBuilder = TheoryUserDataCompanion
    Function({
  required String theoryId,
  Value<bool> isBookmarked,
  Value<bool> isCompleted,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$TheoryUserDataTableUpdateCompanionBuilder = TheoryUserDataCompanion
    Function({
  Value<String> theoryId,
  Value<bool> isBookmarked,
  Value<bool> isCompleted,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$TheoryUserDataTableFilterComposer
    extends Composer<_$AppDatabase, $TheoryUserDataTable> {
  $$TheoryUserDataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get theoryId => $composableBuilder(
      column: $table.theoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isBookmarked => $composableBuilder(
      column: $table.isBookmarked, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$TheoryUserDataTableOrderingComposer
    extends Composer<_$AppDatabase, $TheoryUserDataTable> {
  $$TheoryUserDataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get theoryId => $composableBuilder(
      column: $table.theoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isBookmarked => $composableBuilder(
      column: $table.isBookmarked,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$TheoryUserDataTableAnnotationComposer
    extends Composer<_$AppDatabase, $TheoryUserDataTable> {
  $$TheoryUserDataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get theoryId =>
      $composableBuilder(column: $table.theoryId, builder: (column) => column);

  GeneratedColumn<bool> get isBookmarked => $composableBuilder(
      column: $table.isBookmarked, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TheoryUserDataTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TheoryUserDataTable,
    LocalTheoryUserData,
    $$TheoryUserDataTableFilterComposer,
    $$TheoryUserDataTableOrderingComposer,
    $$TheoryUserDataTableAnnotationComposer,
    $$TheoryUserDataTableCreateCompanionBuilder,
    $$TheoryUserDataTableUpdateCompanionBuilder,
    (
      LocalTheoryUserData,
      BaseReferences<_$AppDatabase, $TheoryUserDataTable, LocalTheoryUserData>
    ),
    LocalTheoryUserData,
    PrefetchHooks Function()> {
  $$TheoryUserDataTableTableManager(
      _$AppDatabase db, $TheoryUserDataTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TheoryUserDataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TheoryUserDataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TheoryUserDataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> theoryId = const Value.absent(),
            Value<bool> isBookmarked = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TheoryUserDataCompanion(
            theoryId: theoryId,
            isBookmarked: isBookmarked,
            isCompleted: isCompleted,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String theoryId,
            Value<bool> isBookmarked = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TheoryUserDataCompanion.insert(
            theoryId: theoryId,
            isBookmarked: isBookmarked,
            isCompleted: isCompleted,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TheoryUserDataTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TheoryUserDataTable,
    LocalTheoryUserData,
    $$TheoryUserDataTableFilterComposer,
    $$TheoryUserDataTableOrderingComposer,
    $$TheoryUserDataTableAnnotationComposer,
    $$TheoryUserDataTableCreateCompanionBuilder,
    $$TheoryUserDataTableUpdateCompanionBuilder,
    (
      LocalTheoryUserData,
      BaseReferences<_$AppDatabase, $TheoryUserDataTable, LocalTheoryUserData>
    ),
    LocalTheoryUserData,
    PrefetchHooks Function()>;
typedef $$HistoricalMatchesTableCreateCompanionBuilder
    = HistoricalMatchesCompanion Function({
  required String id,
  required String whitePlayer,
  required String blackPlayer,
  required String event,
  required int year,
  required String result,
  required String pgn,
  required String description,
  required String tagsJson,
  required String difficulty,
  required int sortOrder,
  Value<int> rowid,
});
typedef $$HistoricalMatchesTableUpdateCompanionBuilder
    = HistoricalMatchesCompanion Function({
  Value<String> id,
  Value<String> whitePlayer,
  Value<String> blackPlayer,
  Value<String> event,
  Value<int> year,
  Value<String> result,
  Value<String> pgn,
  Value<String> description,
  Value<String> tagsJson,
  Value<String> difficulty,
  Value<int> sortOrder,
  Value<int> rowid,
});

class $$HistoricalMatchesTableFilterComposer
    extends Composer<_$AppDatabase, $HistoricalMatchesTable> {
  $$HistoricalMatchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get whitePlayer => $composableBuilder(
      column: $table.whitePlayer, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get blackPlayer => $composableBuilder(
      column: $table.blackPlayer, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get event => $composableBuilder(
      column: $table.event, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get result => $composableBuilder(
      column: $table.result, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pgn => $composableBuilder(
      column: $table.pgn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tagsJson => $composableBuilder(
      column: $table.tagsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));
}

class $$HistoricalMatchesTableOrderingComposer
    extends Composer<_$AppDatabase, $HistoricalMatchesTable> {
  $$HistoricalMatchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get whitePlayer => $composableBuilder(
      column: $table.whitePlayer, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get blackPlayer => $composableBuilder(
      column: $table.blackPlayer, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get event => $composableBuilder(
      column: $table.event, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get result => $composableBuilder(
      column: $table.result, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pgn => $composableBuilder(
      column: $table.pgn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tagsJson => $composableBuilder(
      column: $table.tagsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));
}

class $$HistoricalMatchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HistoricalMatchesTable> {
  $$HistoricalMatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get whitePlayer => $composableBuilder(
      column: $table.whitePlayer, builder: (column) => column);

  GeneratedColumn<String> get blackPlayer => $composableBuilder(
      column: $table.blackPlayer, builder: (column) => column);

  GeneratedColumn<String> get event =>
      $composableBuilder(column: $table.event, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  GeneratedColumn<String> get pgn =>
      $composableBuilder(column: $table.pgn, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get tagsJson =>
      $composableBuilder(column: $table.tagsJson, builder: (column) => column);

  GeneratedColumn<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$HistoricalMatchesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HistoricalMatchesTable,
    LocalHistoricalMatch,
    $$HistoricalMatchesTableFilterComposer,
    $$HistoricalMatchesTableOrderingComposer,
    $$HistoricalMatchesTableAnnotationComposer,
    $$HistoricalMatchesTableCreateCompanionBuilder,
    $$HistoricalMatchesTableUpdateCompanionBuilder,
    (
      LocalHistoricalMatch,
      BaseReferences<_$AppDatabase, $HistoricalMatchesTable,
          LocalHistoricalMatch>
    ),
    LocalHistoricalMatch,
    PrefetchHooks Function()> {
  $$HistoricalMatchesTableTableManager(
      _$AppDatabase db, $HistoricalMatchesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HistoricalMatchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HistoricalMatchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HistoricalMatchesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> whitePlayer = const Value.absent(),
            Value<String> blackPlayer = const Value.absent(),
            Value<String> event = const Value.absent(),
            Value<int> year = const Value.absent(),
            Value<String> result = const Value.absent(),
            Value<String> pgn = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> tagsJson = const Value.absent(),
            Value<String> difficulty = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HistoricalMatchesCompanion(
            id: id,
            whitePlayer: whitePlayer,
            blackPlayer: blackPlayer,
            event: event,
            year: year,
            result: result,
            pgn: pgn,
            description: description,
            tagsJson: tagsJson,
            difficulty: difficulty,
            sortOrder: sortOrder,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String whitePlayer,
            required String blackPlayer,
            required String event,
            required int year,
            required String result,
            required String pgn,
            required String description,
            required String tagsJson,
            required String difficulty,
            required int sortOrder,
            Value<int> rowid = const Value.absent(),
          }) =>
              HistoricalMatchesCompanion.insert(
            id: id,
            whitePlayer: whitePlayer,
            blackPlayer: blackPlayer,
            event: event,
            year: year,
            result: result,
            pgn: pgn,
            description: description,
            tagsJson: tagsJson,
            difficulty: difficulty,
            sortOrder: sortOrder,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HistoricalMatchesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HistoricalMatchesTable,
    LocalHistoricalMatch,
    $$HistoricalMatchesTableFilterComposer,
    $$HistoricalMatchesTableOrderingComposer,
    $$HistoricalMatchesTableAnnotationComposer,
    $$HistoricalMatchesTableCreateCompanionBuilder,
    $$HistoricalMatchesTableUpdateCompanionBuilder,
    (
      LocalHistoricalMatch,
      BaseReferences<_$AppDatabase, $HistoricalMatchesTable,
          LocalHistoricalMatch>
    ),
    LocalHistoricalMatch,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db, _db.games);
  $$MovesTableTableManager get moves =>
      $$MovesTableTableManager(_db, _db.moves);
  $$ProfileTableTableManager get profile =>
      $$ProfileTableTableManager(_db, _db.profile);
  $$CacheMetaTableTableManager get cacheMeta =>
      $$CacheMetaTableTableManager(_db, _db.cacheMeta);
  $$TheoryEntriesTableTableManager get theoryEntries =>
      $$TheoryEntriesTableTableManager(_db, _db.theoryEntries);
  $$TheoryUserDataTableTableManager get theoryUserData =>
      $$TheoryUserDataTableTableManager(_db, _db.theoryUserData);
  $$HistoricalMatchesTableTableManager get historicalMatches =>
      $$HistoricalMatchesTableTableManager(_db, _db.historicalMatches);
}
