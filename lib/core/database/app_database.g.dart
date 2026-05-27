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
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _pgnMeta = const VerificationMeta('pgn');
  @override
  late final GeneratedColumn<String> pgn = GeneratedColumn<String>(
    'pgn',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resultMeta = const VerificationMeta('result');
  @override
  late final GeneratedColumn<String> result = GeneratedColumn<String>(
    'result',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _botLevelMeta = const VerificationMeta(
    'botLevel',
  );
  @override
  late final GeneratedColumn<int> botLevel = GeneratedColumn<int>(
    'bot_level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timeControlSecondsMeta =
      const VerificationMeta('timeControlSeconds');
  @override
  late final GeneratedColumn<int> timeControlSeconds = GeneratedColumn<int>(
    'time_control_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _playedAtMeta = const VerificationMeta(
    'playedAt',
  );
  @override
  late final GeneratedColumn<DateTime> playedAt = GeneratedColumn<DateTime>(
    'played_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _playerAccuracyMeta = const VerificationMeta(
    'playerAccuracy',
  );
  @override
  late final GeneratedColumn<int> playerAccuracy = GeneratedColumn<int>(
    'player_accuracy',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
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
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'games';
  @override
  VerificationContext validateIntegrity(
    Insertable<Game> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pgn')) {
      context.handle(
        _pgnMeta,
        pgn.isAcceptableOrUnknown(data['pgn']!, _pgnMeta),
      );
    } else if (isInserting) {
      context.missing(_pgnMeta);
    }
    if (data.containsKey('result')) {
      context.handle(
        _resultMeta,
        result.isAcceptableOrUnknown(data['result']!, _resultMeta),
      );
    } else if (isInserting) {
      context.missing(_resultMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('bot_level')) {
      context.handle(
        _botLevelMeta,
        botLevel.isAcceptableOrUnknown(data['bot_level']!, _botLevelMeta),
      );
    }
    if (data.containsKey('time_control_seconds')) {
      context.handle(
        _timeControlSecondsMeta,
        timeControlSeconds.isAcceptableOrUnknown(
          data['time_control_seconds']!,
          _timeControlSecondsMeta,
        ),
      );
    }
    if (data.containsKey('played_at')) {
      context.handle(
        _playedAtMeta,
        playedAt.isAcceptableOrUnknown(data['played_at']!, _playedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_playedAtMeta);
    }
    if (data.containsKey('player_accuracy')) {
      context.handle(
        _playerAccuracyMeta,
        playerAccuracy.isAcceptableOrUnknown(
          data['player_accuracy']!,
          _playerAccuracyMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Game map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Game(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      pgn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pgn'],
      )!,
      result: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      botLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bot_level'],
      ),
      timeControlSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_control_seconds'],
      ),
      playedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}played_at'],
      )!,
      playerAccuracy: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}player_accuracy'],
      ),
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
  const Game({
    required this.id,
    required this.pgn,
    required this.result,
    required this.mode,
    this.botLevel,
    this.timeControlSeconds,
    required this.playedAt,
    this.playerAccuracy,
  });
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
    );
  }

  factory Game.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
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
    };
  }

  Game copyWith({
    int? id,
    String? pgn,
    String? result,
    String? mode,
    Value<int?> botLevel = const Value.absent(),
    Value<int?> timeControlSeconds = const Value.absent(),
    DateTime? playedAt,
    Value<int?> playerAccuracy = const Value.absent(),
  }) => Game(
    id: id ?? this.id,
    pgn: pgn ?? this.pgn,
    result: result ?? this.result,
    mode: mode ?? this.mode,
    botLevel: botLevel.present ? botLevel.value : this.botLevel,
    timeControlSeconds: timeControlSeconds.present
        ? timeControlSeconds.value
        : this.timeControlSeconds,
    playedAt: playedAt ?? this.playedAt,
    playerAccuracy: playerAccuracy.present
        ? playerAccuracy.value
        : this.playerAccuracy,
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
          ..write('playerAccuracy: $playerAccuracy')
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
  );
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
          other.playerAccuracy == this.playerAccuracy);
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
  const GamesCompanion({
    this.id = const Value.absent(),
    this.pgn = const Value.absent(),
    this.result = const Value.absent(),
    this.mode = const Value.absent(),
    this.botLevel = const Value.absent(),
    this.timeControlSeconds = const Value.absent(),
    this.playedAt = const Value.absent(),
    this.playerAccuracy = const Value.absent(),
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
  }) : pgn = Value(pgn),
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
    });
  }

  GamesCompanion copyWith({
    Value<int>? id,
    Value<String>? pgn,
    Value<String>? result,
    Value<String>? mode,
    Value<int?>? botLevel,
    Value<int?>? timeControlSeconds,
    Value<DateTime>? playedAt,
    Value<int?>? playerAccuracy,
  }) {
    return GamesCompanion(
      id: id ?? this.id,
      pgn: pgn ?? this.pgn,
      result: result ?? this.result,
      mode: mode ?? this.mode,
      botLevel: botLevel ?? this.botLevel,
      timeControlSeconds: timeControlSeconds ?? this.timeControlSeconds,
      playedAt: playedAt ?? this.playedAt,
      playerAccuracy: playerAccuracy ?? this.playerAccuracy,
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
          ..write('playerAccuracy: $playerAccuracy')
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
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<int> gameId = GeneratedColumn<int>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (id)',
    ),
  );
  static const VerificationMeta _plyMeta = const VerificationMeta('ply');
  @override
  late final GeneratedColumn<int> ply = GeneratedColumn<int>(
    'ply',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uciMeta = const VerificationMeta('uci');
  @override
  late final GeneratedColumn<String> uci = GeneratedColumn<String>(
    'uci',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sanMeta = const VerificationMeta('san');
  @override
  late final GeneratedColumn<String> san = GeneratedColumn<String>(
    'san',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _evalCentipawnsMeta = const VerificationMeta(
    'evalCentipawns',
  );
  @override
  late final GeneratedColumn<int> evalCentipawns = GeneratedColumn<int>(
    'eval_centipawns',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _classificationMeta = const VerificationMeta(
    'classification',
  );
  @override
  late final GeneratedColumn<String> classification = GeneratedColumn<String>(
    'classification',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gameId,
    ply,
    uci,
    san,
    evalCentipawns,
    classification,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'moves';
  @override
  VerificationContext validateIntegrity(
    Insertable<Move> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('ply')) {
      context.handle(
        _plyMeta,
        ply.isAcceptableOrUnknown(data['ply']!, _plyMeta),
      );
    } else if (isInserting) {
      context.missing(_plyMeta);
    }
    if (data.containsKey('uci')) {
      context.handle(
        _uciMeta,
        uci.isAcceptableOrUnknown(data['uci']!, _uciMeta),
      );
    } else if (isInserting) {
      context.missing(_uciMeta);
    }
    if (data.containsKey('san')) {
      context.handle(
        _sanMeta,
        san.isAcceptableOrUnknown(data['san']!, _sanMeta),
      );
    } else if (isInserting) {
      context.missing(_sanMeta);
    }
    if (data.containsKey('eval_centipawns')) {
      context.handle(
        _evalCentipawnsMeta,
        evalCentipawns.isAcceptableOrUnknown(
          data['eval_centipawns']!,
          _evalCentipawnsMeta,
        ),
      );
    }
    if (data.containsKey('classification')) {
      context.handle(
        _classificationMeta,
        classification.isAcceptableOrUnknown(
          data['classification']!,
          _classificationMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Move map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Move(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_id'],
      )!,
      ply: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ply'],
      )!,
      uci: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uci'],
      )!,
      san: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}san'],
      )!,
      evalCentipawns: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}eval_centipawns'],
      ),
      classification: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}classification'],
      ),
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
  const Move({
    required this.id,
    required this.gameId,
    required this.ply,
    required this.uci,
    required this.san,
    this.evalCentipawns,
    this.classification,
  });
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
    );
  }

  factory Move.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Move(
      id: serializer.fromJson<int>(json['id']),
      gameId: serializer.fromJson<int>(json['gameId']),
      ply: serializer.fromJson<int>(json['ply']),
      uci: serializer.fromJson<String>(json['uci']),
      san: serializer.fromJson<String>(json['san']),
      evalCentipawns: serializer.fromJson<int?>(json['evalCentipawns']),
      classification: serializer.fromJson<String?>(json['classification']),
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
    };
  }

  Move copyWith({
    int? id,
    int? gameId,
    int? ply,
    String? uci,
    String? san,
    Value<int?> evalCentipawns = const Value.absent(),
    Value<String?> classification = const Value.absent(),
  }) => Move(
    id: id ?? this.id,
    gameId: gameId ?? this.gameId,
    ply: ply ?? this.ply,
    uci: uci ?? this.uci,
    san: san ?? this.san,
    evalCentipawns: evalCentipawns.present
        ? evalCentipawns.value
        : this.evalCentipawns,
    classification: classification.present
        ? classification.value
        : this.classification,
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
          ..write('classification: $classification')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, gameId, ply, uci, san, evalCentipawns, classification);
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
          other.classification == this.classification);
}

class MovesCompanion extends UpdateCompanion<Move> {
  final Value<int> id;
  final Value<int> gameId;
  final Value<int> ply;
  final Value<String> uci;
  final Value<String> san;
  final Value<int?> evalCentipawns;
  final Value<String?> classification;
  const MovesCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.ply = const Value.absent(),
    this.uci = const Value.absent(),
    this.san = const Value.absent(),
    this.evalCentipawns = const Value.absent(),
    this.classification = const Value.absent(),
  });
  MovesCompanion.insert({
    this.id = const Value.absent(),
    required int gameId,
    required int ply,
    required String uci,
    required String san,
    this.evalCentipawns = const Value.absent(),
    this.classification = const Value.absent(),
  }) : gameId = Value(gameId),
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
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (ply != null) 'ply': ply,
      if (uci != null) 'uci': uci,
      if (san != null) 'san': san,
      if (evalCentipawns != null) 'eval_centipawns': evalCentipawns,
      if (classification != null) 'classification': classification,
    });
  }

  MovesCompanion copyWith({
    Value<int>? id,
    Value<int>? gameId,
    Value<int>? ply,
    Value<String>? uci,
    Value<String>? san,
    Value<int?>? evalCentipawns,
    Value<String?>? classification,
  }) {
    return MovesCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      ply: ply ?? this.ply,
      uci: uci ?? this.uci,
      san: san ?? this.san,
      evalCentipawns: evalCentipawns ?? this.evalCentipawns,
      classification: classification ?? this.classification,
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
          ..write('classification: $classification')
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
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Player'),
  );
  static const VerificationMeta _avatarPathMeta = const VerificationMeta(
    'avatarPath',
  );
  @override
  late final GeneratedColumn<String> avatarPath = GeneratedColumn<String>(
    'avatar_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentRatingMeta = const VerificationMeta(
    'currentRating',
  );
  @override
  late final GeneratedColumn<int> currentRating = GeneratedColumn<int>(
    'current_rating',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(800),
  );
  static const VerificationMeta _peakRatingMeta = const VerificationMeta(
    'peakRating',
  );
  @override
  late final GeneratedColumn<int> peakRating = GeneratedColumn<int>(
    'peak_rating',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(800),
  );
  static const VerificationMeta _gamesPlayedMeta = const VerificationMeta(
    'gamesPlayed',
  );
  @override
  late final GeneratedColumn<int> gamesPlayed = GeneratedColumn<int>(
    'games_played',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _winsMeta = const VerificationMeta('wins');
  @override
  late final GeneratedColumn<int> wins = GeneratedColumn<int>(
    'wins',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _drawsMeta = const VerificationMeta('draws');
  @override
  late final GeneratedColumn<int> draws = GeneratedColumn<int>(
    'draws',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lossesMeta = const VerificationMeta('losses');
  @override
  late final GeneratedColumn<int> losses = GeneratedColumn<int>(
    'losses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
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
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profile';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    }
    if (data.containsKey('avatar_path')) {
      context.handle(
        _avatarPathMeta,
        avatarPath.isAcceptableOrUnknown(data['avatar_path']!, _avatarPathMeta),
      );
    }
    if (data.containsKey('current_rating')) {
      context.handle(
        _currentRatingMeta,
        currentRating.isAcceptableOrUnknown(
          data['current_rating']!,
          _currentRatingMeta,
        ),
      );
    }
    if (data.containsKey('peak_rating')) {
      context.handle(
        _peakRatingMeta,
        peakRating.isAcceptableOrUnknown(data['peak_rating']!, _peakRatingMeta),
      );
    }
    if (data.containsKey('games_played')) {
      context.handle(
        _gamesPlayedMeta,
        gamesPlayed.isAcceptableOrUnknown(
          data['games_played']!,
          _gamesPlayedMeta,
        ),
      );
    }
    if (data.containsKey('wins')) {
      context.handle(
        _winsMeta,
        wins.isAcceptableOrUnknown(data['wins']!, _winsMeta),
      );
    }
    if (data.containsKey('draws')) {
      context.handle(
        _drawsMeta,
        draws.isAcceptableOrUnknown(data['draws']!, _drawsMeta),
      );
    }
    if (data.containsKey('losses')) {
      context.handle(
        _lossesMeta,
        losses.isAcceptableOrUnknown(data['losses']!, _lossesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
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
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      avatarPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_path'],
      ),
      currentRating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_rating'],
      )!,
      peakRating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}peak_rating'],
      )!,
      gamesPlayed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}games_played'],
      )!,
      wins: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wins'],
      )!,
      draws: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}draws'],
      )!,
      losses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}losses'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
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
  final DateTime createdAt;
  const ProfileData({
    required this.id,
    required this.username,
    this.avatarPath,
    required this.currentRating,
    required this.peakRating,
    required this.gamesPlayed,
    required this.wins,
    required this.draws,
    required this.losses,
    required this.createdAt,
  });
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
      createdAt: Value(createdAt),
    );
  }

  factory ProfileData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
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
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ProfileData copyWith({
    int? id,
    String? username,
    Value<String?> avatarPath = const Value.absent(),
    int? currentRating,
    int? peakRating,
    int? gamesPlayed,
    int? wins,
    int? draws,
    int? losses,
    DateTime? createdAt,
  }) => ProfileData(
    id: id ?? this.id,
    username: username ?? this.username,
    avatarPath: avatarPath.present ? avatarPath.value : this.avatarPath,
    currentRating: currentRating ?? this.currentRating,
    peakRating: peakRating ?? this.peakRating,
    gamesPlayed: gamesPlayed ?? this.gamesPlayed,
    wins: wins ?? this.wins,
    draws: draws ?? this.draws,
    losses: losses ?? this.losses,
    createdAt: createdAt ?? this.createdAt,
  );
  ProfileData copyWithCompanion(ProfileCompanion data) {
    return ProfileData(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      avatarPath: data.avatarPath.present
          ? data.avatarPath.value
          : this.avatarPath,
      currentRating: data.currentRating.present
          ? data.currentRating.value
          : this.currentRating,
      peakRating: data.peakRating.present
          ? data.peakRating.value
          : this.peakRating,
      gamesPlayed: data.gamesPlayed.present
          ? data.gamesPlayed.value
          : this.gamesPlayed,
      wins: data.wins.present ? data.wins.value : this.wins,
      draws: data.draws.present ? data.draws.value : this.draws,
      losses: data.losses.present ? data.losses.value : this.losses,
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
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    username,
    avatarPath,
    currentRating,
    peakRating,
    gamesPlayed,
    wins,
    draws,
    losses,
    createdAt,
  );
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
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProfileCompanion copyWith({
    Value<int>? id,
    Value<String>? username,
    Value<String?>? avatarPath,
    Value<int>? currentRating,
    Value<int>? peakRating,
    Value<int>? gamesPlayed,
    Value<int>? wins,
    Value<int>? draws,
    Value<int>? losses,
    Value<DateTime>? createdAt,
  }) {
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
          ..write('createdAt: $createdAt')
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
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [games, moves, profile];
}

typedef $$GamesTableCreateCompanionBuilder =
    GamesCompanion Function({
      Value<int> id,
      required String pgn,
      required String result,
      required String mode,
      Value<int?> botLevel,
      Value<int?> timeControlSeconds,
      required DateTime playedAt,
      Value<int?> playerAccuracy,
    });
typedef $$GamesTableUpdateCompanionBuilder =
    GamesCompanion Function({
      Value<int> id,
      Value<String> pgn,
      Value<String> result,
      Value<String> mode,
      Value<int?> botLevel,
      Value<int?> timeControlSeconds,
      Value<DateTime> playedAt,
      Value<int?> playerAccuracy,
    });

final class $$GamesTableReferences
    extends BaseReferences<_$AppDatabase, $GamesTable, Game> {
  $$GamesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MovesTable, List<Move>> _movesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.moves,
    aliasName: $_aliasNameGenerator(db.games.id, db.moves.gameId),
  );

  $$MovesTableProcessedTableManager get movesRefs {
    final manager = $$MovesTableTableManager(
      $_db,
      $_db.moves,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_movesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
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
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pgn => $composableBuilder(
    column: $table.pgn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get botLevel => $composableBuilder(
    column: $table.botLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeControlSeconds => $composableBuilder(
    column: $table.timeControlSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get playedAt => $composableBuilder(
    column: $table.playedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get playerAccuracy => $composableBuilder(
    column: $table.playerAccuracy,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> movesRefs(
    Expression<bool> Function($$MovesTableFilterComposer f) f,
  ) {
    final $$MovesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.moves,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovesTableFilterComposer(
            $db: $db,
            $table: $db.moves,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
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
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pgn => $composableBuilder(
    column: $table.pgn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get botLevel => $composableBuilder(
    column: $table.botLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeControlSeconds => $composableBuilder(
    column: $table.timeControlSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get playedAt => $composableBuilder(
    column: $table.playedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get playerAccuracy => $composableBuilder(
    column: $table.playerAccuracy,
    builder: (column) => ColumnOrderings(column),
  );
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
    column: $table.timeControlSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get playedAt =>
      $composableBuilder(column: $table.playedAt, builder: (column) => column);

  GeneratedColumn<int> get playerAccuracy => $composableBuilder(
    column: $table.playerAccuracy,
    builder: (column) => column,
  );

  Expression<T> movesRefs<T extends Object>(
    Expression<T> Function($$MovesTableAnnotationComposer a) f,
  ) {
    final $$MovesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.moves,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovesTableAnnotationComposer(
            $db: $db,
            $table: $db.moves,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GamesTableTableManager
    extends
        RootTableManager<
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
          PrefetchHooks Function({bool movesRefs})
        > {
  $$GamesTableTableManager(_$AppDatabase db, $GamesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> pgn = const Value.absent(),
                Value<String> result = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<int?> botLevel = const Value.absent(),
                Value<int?> timeControlSeconds = const Value.absent(),
                Value<DateTime> playedAt = const Value.absent(),
                Value<int?> playerAccuracy = const Value.absent(),
              }) => GamesCompanion(
                id: id,
                pgn: pgn,
                result: result,
                mode: mode,
                botLevel: botLevel,
                timeControlSeconds: timeControlSeconds,
                playedAt: playedAt,
                playerAccuracy: playerAccuracy,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String pgn,
                required String result,
                required String mode,
                Value<int?> botLevel = const Value.absent(),
                Value<int?> timeControlSeconds = const Value.absent(),
                required DateTime playedAt,
                Value<int?> playerAccuracy = const Value.absent(),
              }) => GamesCompanion.insert(
                id: id,
                pgn: pgn,
                result: result,
                mode: mode,
                botLevel: botLevel,
                timeControlSeconds: timeControlSeconds,
                playedAt: playedAt,
                playerAccuracy: playerAccuracy,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GamesTableReferences(db, table, e)),
              )
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
                      referencedTable: $$GamesTableReferences._movesRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$GamesTableReferences(db, table, p0).movesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.gameId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$GamesTableProcessedTableManager =
    ProcessedTableManager<
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
      PrefetchHooks Function({bool movesRefs})
    >;
typedef $$MovesTableCreateCompanionBuilder =
    MovesCompanion Function({
      Value<int> id,
      required int gameId,
      required int ply,
      required String uci,
      required String san,
      Value<int?> evalCentipawns,
      Value<String?> classification,
    });
typedef $$MovesTableUpdateCompanionBuilder =
    MovesCompanion Function({
      Value<int> id,
      Value<int> gameId,
      Value<int> ply,
      Value<String> uci,
      Value<String> san,
      Value<int?> evalCentipawns,
      Value<String?> classification,
    });

final class $$MovesTableReferences
    extends BaseReferences<_$AppDatabase, $MovesTable, Move> {
  $$MovesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GamesTable _gameIdTable(_$AppDatabase db) =>
      db.games.createAlias($_aliasNameGenerator(db.moves.gameId, db.games.id));

  $$GamesTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<int>('game_id')!;

    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
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
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ply => $composableBuilder(
    column: $table.ply,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uci => $composableBuilder(
    column: $table.uci,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get san => $composableBuilder(
    column: $table.san,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get evalCentipawns => $composableBuilder(
    column: $table.evalCentipawns,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => ColumnFilters(column),
  );

  $$GamesTableFilterComposer get gameId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
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
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ply => $composableBuilder(
    column: $table.ply,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uci => $composableBuilder(
    column: $table.uci,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get san => $composableBuilder(
    column: $table.san,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get evalCentipawns => $composableBuilder(
    column: $table.evalCentipawns,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => ColumnOrderings(column),
  );

  $$GamesTableOrderingComposer get gameId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableOrderingComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
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
    column: $table.evalCentipawns,
    builder: (column) => column,
  );

  GeneratedColumn<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => column,
  );

  $$GamesTableAnnotationComposer get gameId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovesTableTableManager
    extends
        RootTableManager<
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
          PrefetchHooks Function({bool gameId})
        > {
  $$MovesTableTableManager(_$AppDatabase db, $MovesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MovesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MovesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MovesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> gameId = const Value.absent(),
                Value<int> ply = const Value.absent(),
                Value<String> uci = const Value.absent(),
                Value<String> san = const Value.absent(),
                Value<int?> evalCentipawns = const Value.absent(),
                Value<String?> classification = const Value.absent(),
              }) => MovesCompanion(
                id: id,
                gameId: gameId,
                ply: ply,
                uci: uci,
                san: san,
                evalCentipawns: evalCentipawns,
                classification: classification,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int gameId,
                required int ply,
                required String uci,
                required String san,
                Value<int?> evalCentipawns = const Value.absent(),
                Value<String?> classification = const Value.absent(),
              }) => MovesCompanion.insert(
                id: id,
                gameId: gameId,
                ply: ply,
                uci: uci,
                san: san,
                evalCentipawns: evalCentipawns,
                classification: classification,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$MovesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({gameId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (gameId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.gameId,
                                referencedTable: $$MovesTableReferences
                                    ._gameIdTable(db),
                                referencedColumn: $$MovesTableReferences
                                    ._gameIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MovesTableProcessedTableManager =
    ProcessedTableManager<
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
      PrefetchHooks Function({bool gameId})
    >;
typedef $$ProfileTableCreateCompanionBuilder =
    ProfileCompanion Function({
      Value<int> id,
      Value<String> username,
      Value<String?> avatarPath,
      Value<int> currentRating,
      Value<int> peakRating,
      Value<int> gamesPlayed,
      Value<int> wins,
      Value<int> draws,
      Value<int> losses,
      required DateTime createdAt,
    });
typedef $$ProfileTableUpdateCompanionBuilder =
    ProfileCompanion Function({
      Value<int> id,
      Value<String> username,
      Value<String?> avatarPath,
      Value<int> currentRating,
      Value<int> peakRating,
      Value<int> gamesPlayed,
      Value<int> wins,
      Value<int> draws,
      Value<int> losses,
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
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentRating => $composableBuilder(
    column: $table.currentRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get peakRating => $composableBuilder(
    column: $table.peakRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gamesPlayed => $composableBuilder(
    column: $table.gamesPlayed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wins => $composableBuilder(
    column: $table.wins,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get draws => $composableBuilder(
    column: $table.draws,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get losses => $composableBuilder(
    column: $table.losses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
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
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentRating => $composableBuilder(
    column: $table.currentRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get peakRating => $composableBuilder(
    column: $table.peakRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gamesPlayed => $composableBuilder(
    column: $table.gamesPlayed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wins => $composableBuilder(
    column: $table.wins,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get draws => $composableBuilder(
    column: $table.draws,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get losses => $composableBuilder(
    column: $table.losses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
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
    column: $table.avatarPath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentRating => $composableBuilder(
    column: $table.currentRating,
    builder: (column) => column,
  );

  GeneratedColumn<int> get peakRating => $composableBuilder(
    column: $table.peakRating,
    builder: (column) => column,
  );

  GeneratedColumn<int> get gamesPlayed => $composableBuilder(
    column: $table.gamesPlayed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wins =>
      $composableBuilder(column: $table.wins, builder: (column) => column);

  GeneratedColumn<int> get draws =>
      $composableBuilder(column: $table.draws, builder: (column) => column);

  GeneratedColumn<int> get losses =>
      $composableBuilder(column: $table.losses, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ProfileTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfileTable,
          ProfileData,
          $$ProfileTableFilterComposer,
          $$ProfileTableOrderingComposer,
          $$ProfileTableAnnotationComposer,
          $$ProfileTableCreateCompanionBuilder,
          $$ProfileTableUpdateCompanionBuilder,
          (
            ProfileData,
            BaseReferences<_$AppDatabase, $ProfileTable, ProfileData>,
          ),
          ProfileData,
          PrefetchHooks Function()
        > {
  $$ProfileTableTableManager(_$AppDatabase db, $ProfileTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfileTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfileTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfileTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String?> avatarPath = const Value.absent(),
                Value<int> currentRating = const Value.absent(),
                Value<int> peakRating = const Value.absent(),
                Value<int> gamesPlayed = const Value.absent(),
                Value<int> wins = const Value.absent(),
                Value<int> draws = const Value.absent(),
                Value<int> losses = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProfileCompanion(
                id: id,
                username: username,
                avatarPath: avatarPath,
                currentRating: currentRating,
                peakRating: peakRating,
                gamesPlayed: gamesPlayed,
                wins: wins,
                draws: draws,
                losses: losses,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String?> avatarPath = const Value.absent(),
                Value<int> currentRating = const Value.absent(),
                Value<int> peakRating = const Value.absent(),
                Value<int> gamesPlayed = const Value.absent(),
                Value<int> wins = const Value.absent(),
                Value<int> draws = const Value.absent(),
                Value<int> losses = const Value.absent(),
                required DateTime createdAt,
              }) => ProfileCompanion.insert(
                id: id,
                username: username,
                avatarPath: avatarPath,
                currentRating: currentRating,
                peakRating: peakRating,
                gamesPlayed: gamesPlayed,
                wins: wins,
                draws: draws,
                losses: losses,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfileTableProcessedTableManager =
    ProcessedTableManager<
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
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db, _db.games);
  $$MovesTableTableManager get moves =>
      $$MovesTableTableManager(_db, _db.moves);
  $$ProfileTableTableManager get profile =>
      $$ProfileTableTableManager(_db, _db.profile);
}
