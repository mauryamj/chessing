import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  String get summary {
    final colorStr = playerColor == PlayerColor.white
        ? 'White'
        : (playerColor == PlayerColor.black ? 'Black' : 'Random');
    switch (mode) {
      case GameMode.timed:
        return '${timeControl.label} • $colorStr';
      case GameMode.level:
        return 'Bot Level $botLevel • $colorStr';
      case GameMode.free:
        return 'Free Play • $colorStr';
    }
  }

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
  static const _kMode = 'game_config_mode';
  static const _kTimeControl = 'game_config_time_control';
  static const _kBotLevel = 'game_config_bot_level';
  static const _kPlayerColor = 'game_config_player_color';

  GameConfigNotifier()
      : super(GameConfig(
          mode: GameMode.level,
          timeControl: TimeControl.blitz5_0,
          botLevel: 3,
          playerColor: PlayerColor.white,
        )) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final modeStr = prefs.getString(_kMode);
      final tcStr = prefs.getString(_kTimeControl);
      final botLevel = prefs.getInt(_kBotLevel);
      final colorStr = prefs.getString(_kPlayerColor);

      GameMode mode = state.mode;
      if (modeStr != null) {
        mode = GameMode.values.firstWhere(
          (e) => e.name == modeStr,
          orElse: () => mode,
        );
      }
      TimeControl tc = state.timeControl;
      if (tcStr != null) {
        tc = TimeControl.values.firstWhere(
          (e) => e.name == tcStr,
          orElse: () => tc,
        );
      }
      final level = botLevel ?? state.botLevel;
      PlayerColor color = state.playerColor;
      if (colorStr != null) {
        color = PlayerColor.values.firstWhere(
          (e) => e.name == colorStr,
          orElse: () => color,
        );
      }

      state = GameConfig(
        mode: mode,
        timeControl: tc,
        botLevel: level,
        playerColor: color,
      );
    } catch (_) {}
  }

  Future<void> _saveToPrefs(GameConfig config) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kMode, config.mode.name);
      await prefs.setString(_kTimeControl, config.timeControl.name);
      await prefs.setInt(_kBotLevel, config.botLevel);
      await prefs.setString(_kPlayerColor, config.playerColor.name);
    } catch (_) {}
  }

  void setMode(GameMode mode) {
    state = state.copyWith(mode: mode);
    _saveToPrefs(state);
  }

  void setTimeControl(TimeControl timeControl) {
    state = state.copyWith(timeControl: timeControl);
    _saveToPrefs(state);
  }

  void setBotLevel(int botLevel) {
    state = state.copyWith(botLevel: botLevel);
    _saveToPrefs(state);
  }

  void setPlayerColor(PlayerColor color) {
    state = state.copyWith(playerColor: color);
    _saveToPrefs(state);
  }
}

final gameConfigProvider =
    StateNotifierProvider<GameConfigNotifier, GameConfig>((ref) {
  return GameConfigNotifier();
});
