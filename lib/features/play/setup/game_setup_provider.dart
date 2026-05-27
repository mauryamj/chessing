import 'package:flutter_riverpod/flutter_riverpod.dart';

enum GameMode { timed, free, level }

enum TimeControl {
  bullet1_0('Bullet 1+0', Duration(minutes: 1), 0),
  blitz3_2('Blitz 3+2', Duration(minutes: 3), 2),
  blitz5_0('Blitz 5+0', Duration(minutes: 5), 0),
  rapid10_0('Rapid 10+0', Duration(minutes: 10), 0),
  rapid15_10('Rapid 15+10', Duration(minutes: 15), 10);

  final String label;
  final Duration duration;
  final int incrementSeconds;
  const TimeControl(this.label, this.duration, this.incrementSeconds);
}

enum PlayerColor { white, black, random }

class GameConfig {
  final GameMode mode;
  final TimeControl timeControl;
  final int botLevel; // 1 to 10
  final PlayerColor playerColor;

  GameConfig({
    required this.mode,
    required this.timeControl,
    required this.botLevel,
    required this.playerColor,
  });

  GameConfig copyWith({
    GameMode? mode,
    TimeControl? timeControl,
    int? botLevel,
    PlayerColor? playerColor,
  }) {
    return GameConfig(
      mode: mode ?? this.mode,
      timeControl: timeControl ?? this.timeControl,
      botLevel: botLevel ?? this.botLevel,
      playerColor: playerColor ?? this.playerColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameConfig &&
          runtimeType == other.runtimeType &&
          mode == other.mode &&
          timeControl == other.timeControl &&
          botLevel == other.botLevel &&
          playerColor == other.playerColor;

  @override
  int get hashCode =>
      mode.hashCode ^
      timeControl.hashCode ^
      botLevel.hashCode ^
      playerColor.hashCode;

  Map<String, dynamic> toJson() {
    return {
      'mode': mode.name,
      'timeControl': timeControl.name,
      'botLevel': botLevel,
      'playerColor': playerColor.name,
    };
  }

  factory GameConfig.fromJson(Map<String, dynamic> json) {
    return GameConfig(
      mode: GameMode.values.byName(json['mode'] as String),
      timeControl: TimeControl.values.byName(json['timeControl'] as String),
      botLevel: json['botLevel'] as int,
      playerColor: PlayerColor.values.byName(json['playerColor'] as String),
    );
  }
}

class GameConfigNotifier extends StateNotifier<GameConfig> {
  GameConfigNotifier()
      : super(GameConfig(
          mode: GameMode.level,
          timeControl: TimeControl.blitz5_0,
          botLevel: 3,
          playerColor: PlayerColor.white,
        ));

  void setMode(GameMode mode) {
    state = state.copyWith(mode: mode);
  }

  void setTimeControl(TimeControl timeControl) {
    state = state.copyWith(timeControl: timeControl);
  }

  void setBotLevel(int botLevel) {
    state = state.copyWith(botLevel: botLevel);
  }

  void setPlayerColor(PlayerColor color) {
    state = state.copyWith(playerColor: color);
  }
}

final gameConfigProvider =
    StateNotifierProvider<GameConfigNotifier, GameConfig>((ref) {
  return GameConfigNotifier();
});
