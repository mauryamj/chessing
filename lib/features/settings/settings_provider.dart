import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/firebase/fcm_service.dart';

enum BoardThemeType { classic, wood, neon, minimal }

extension BoardThemeTypeLabel on BoardThemeType {
  String get label {
    switch (this) {
      case BoardThemeType.classic:
        return 'Classic';
      case BoardThemeType.wood:
        return 'Wood';
      case BoardThemeType.neon:
        return 'Neon';
      case BoardThemeType.minimal:
        return 'Minimal';
    }
  }

  IconData get icon {
    switch (this) {
      case BoardThemeType.classic:
        return Icons.grid_4x4;
      case BoardThemeType.wood:
        return Icons.park_rounded;
      case BoardThemeType.neon:
        return Icons.auto_awesome;
      case BoardThemeType.minimal:
        return Icons.square_outlined;
    }
  }
}

enum PieceSetType { standard, neo, alpha }

extension PieceSetTypeLabel on PieceSetType {
  String get label {
    switch (this) {
      case PieceSetType.standard:
        return 'Standard';
      case PieceSetType.neo:
        return 'Neo';
      case PieceSetType.alpha:
        return 'Alpha';
    }
  }
}

class AppSettings {
  final ThemeMode themeMode;
  final BoardThemeType boardTheme;
  final PieceSetType pieceSet;
  final bool showLegalMoves;
  final bool showThreatOverlay;
  final bool autoQueenPromotion;
  final bool moveConfirmation;
  final bool soundEnabled;
  final bool hapticsEnabled;
  final double moveSoundVolume;
  final bool dailyReminderEnabled;
  final int dailyReminderHour;
  final int dailyReminderMinute;
  final bool achievementNotifications;

  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.boardTheme = BoardThemeType.classic,
    this.pieceSet = PieceSetType.standard,
    this.showLegalMoves = true,
    this.showThreatOverlay = false,
    this.autoQueenPromotion = false,
    this.moveConfirmation = false,
    this.soundEnabled = true,
    this.hapticsEnabled = true,
    this.moveSoundVolume = 1.0,
    this.dailyReminderEnabled = false,
    this.dailyReminderHour = 20,
    this.dailyReminderMinute = 0,
    this.achievementNotifications = true,
  });

  TimeOfDay get dailyReminderTime => TimeOfDay(
        hour: dailyReminderHour,
        minute: dailyReminderMinute,
      );

  AppSettings copyWith({
    ThemeMode? themeMode,
    BoardThemeType? boardTheme,
    PieceSetType? pieceSet,
    bool? showLegalMoves,
    bool? showThreatOverlay,
    bool? autoQueenPromotion,
    bool? moveConfirmation,
    bool? soundEnabled,
    bool? hapticsEnabled,
    double? moveSoundVolume,
    bool? dailyReminderEnabled,
    int? dailyReminderHour,
    int? dailyReminderMinute,
    bool? achievementNotifications,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      boardTheme: boardTheme ?? this.boardTheme,
      pieceSet: pieceSet ?? this.pieceSet,
      showLegalMoves: showLegalMoves ?? this.showLegalMoves,
      showThreatOverlay: showThreatOverlay ?? this.showThreatOverlay,
      autoQueenPromotion: autoQueenPromotion ?? this.autoQueenPromotion,
      moveConfirmation: moveConfirmation ?? this.moveConfirmation,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      moveSoundVolume: moveSoundVolume ?? this.moveSoundVolume,
      dailyReminderEnabled: dailyReminderEnabled ?? this.dailyReminderEnabled,
      dailyReminderHour: dailyReminderHour ?? this.dailyReminderHour,
      dailyReminderMinute: dailyReminderMinute ?? this.dailyReminderMinute,
      achievementNotifications: achievementNotifications ?? this.achievementNotifications,
    );
  }
}

const _kThemeMode = 'settings_theme_mode';
const _kBoardTheme = 'settings_board_theme';
const _kPieceSet = 'settings_piece_set';
const _kShowLegalMoves = 'settings_show_legal_moves';
const _kShowThreatOverlay = 'settings_show_threat_overlay';
const _kAutoQueenPromotion = 'settings_auto_queen_promotion';
const _kMoveConfirmation = 'settings_move_confirmation';
const _kSound = 'settings_sound';
const _kHaptics = 'settings_haptics';
const _kMoveSoundVolume = 'settings_move_sound_volume';
const _kDailyReminderEnabled = 'settings_daily_reminder_enabled';
const _kDailyReminderHour = 'settings_daily_reminder_hour';
const _kDailyReminderMinute = 'settings_daily_reminder_minute';
const _kAchievementNotifications = 'settings_achievement_notifications';

class SettingsNotifier extends AsyncNotifier<AppSettings> {
  late SharedPreferences _prefs;

  @override
  Future<AppSettings> build() async {
    _prefs = await SharedPreferences.getInstance();
    return _load();
  }

  AppSettings _load() {
    final themeModeIndex = _prefs.getInt(_kThemeMode) ?? ThemeMode.system.index;
    final boardThemeIndex = _prefs.getInt(_kBoardTheme) ?? 0;
    final pieceSetIndex = _prefs.getInt(_kPieceSet) ?? 0;
    final showLegalMoves = _prefs.getBool(_kShowLegalMoves) ?? true;
    final showThreatOverlay = _prefs.getBool(_kShowThreatOverlay) ?? false;
    final autoQueenPromotion = _prefs.getBool(_kAutoQueenPromotion) ?? false;
    final moveConfirmation = _prefs.getBool(_kMoveConfirmation) ?? false;
    final sound = _prefs.getBool(_kSound) ?? true;
    final haptics = _prefs.getBool(_kHaptics) ?? true;
    final volume = _prefs.getDouble(_kMoveSoundVolume) ?? 1.0;
    final dailyReminder = _prefs.getBool(_kDailyReminderEnabled) ?? false;
    final dailyHour = _prefs.getInt(_kDailyReminderHour) ?? 20;
    final dailyMin = _prefs.getInt(_kDailyReminderMinute) ?? 0;
    final achievements = _prefs.getBool(_kAchievementNotifications) ?? true;

    return AppSettings(
      themeMode: ThemeMode.values[themeModeIndex],
      boardTheme: BoardThemeType.values[boardThemeIndex],
      pieceSet: PieceSetType.values[pieceSetIndex],
      showLegalMoves: showLegalMoves,
      showThreatOverlay: showThreatOverlay,
      autoQueenPromotion: autoQueenPromotion,
      moveConfirmation: moveConfirmation,
      soundEnabled: sound,
      hapticsEnabled: haptics,
      moveSoundVolume: volume,
      dailyReminderEnabled: dailyReminder,
      dailyReminderHour: dailyHour,
      dailyReminderMinute: dailyMin,
      achievementNotifications: achievements,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setInt(_kThemeMode, mode.index);
    state = AsyncData(state.value!.copyWith(themeMode: mode));
  }

  Future<void> setBoardTheme(BoardThemeType theme) async {
    await _prefs.setInt(_kBoardTheme, theme.index);
    state = AsyncData(state.value!.copyWith(boardTheme: theme));
  }

  Future<void> setPieceSet(PieceSetType pieceSet) async {
    await _prefs.setInt(_kPieceSet, pieceSet.index);
    state = AsyncData(state.value!.copyWith(pieceSet: pieceSet));
  }

  Future<void> setShowLegalMoves(bool value) async {
    await _prefs.setBool(_kShowLegalMoves, value);
    state = AsyncData(state.value!.copyWith(showLegalMoves: value));
  }

  Future<void> setShowThreatOverlay(bool value) async {
    await _prefs.setBool(_kShowThreatOverlay, value);
    state = AsyncData(state.value!.copyWith(showThreatOverlay: value));
  }

  Future<void> setAutoQueenPromotion(bool value) async {
    await _prefs.setBool(_kAutoQueenPromotion, value);
    state = AsyncData(state.value!.copyWith(autoQueenPromotion: value));
  }

  Future<void> setMoveConfirmation(bool value) async {
    await _prefs.setBool(_kMoveConfirmation, value);
    state = AsyncData(state.value!.copyWith(moveConfirmation: value));
  }

  Future<void> setSound(bool enabled) async {
    await _prefs.setBool(_kSound, enabled);
    state = AsyncData(state.value!.copyWith(soundEnabled: enabled));
  }

  Future<void> setHaptics(bool enabled) async {
    await _prefs.setBool(_kHaptics, enabled);
    state = AsyncData(state.value!.copyWith(hapticsEnabled: enabled));
  }

  Future<void> setMoveSoundVolume(double volume) async {
    await _prefs.setDouble(_kMoveSoundVolume, volume);
    state = AsyncData(state.value!.copyWith(moveSoundVolume: volume));
  }

  Future<void> setDailyReminderEnabled(bool enabled) async {
    await _prefs.setBool(_kDailyReminderEnabled, enabled);
    state = AsyncData(state.value!.copyWith(dailyReminderEnabled: enabled));
    
    try {
      if (enabled) {
        await FcmService().scheduleDailyReminder(state.value!.dailyReminderTime);
      } else {
        await FcmService().cancelDailyReminder();
      }
    } catch (_) {}
  }

  Future<void> setDailyReminderTime(TimeOfDay time) async {
    await _prefs.setInt(_kDailyReminderHour, time.hour);
    await _prefs.setInt(_kDailyReminderMinute, time.minute);
    state = AsyncData(state.value!.copyWith(
      dailyReminderHour: time.hour,
      dailyReminderMinute: time.minute,
    ));
    
    try {
      if (state.value!.dailyReminderEnabled) {
        await FcmService().scheduleDailyReminder(time);
      }
    } catch (_) {}
  }

  Future<void> setAchievementNotifications(bool enabled) async {
    await _prefs.setBool(_kAchievementNotifications, enabled);
    state = AsyncData(state.value!.copyWith(achievementNotifications: enabled));
  }
}

final settingsProvider = AsyncNotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);

final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(settingsProvider).value?.themeMode ?? ThemeMode.system;
});

final boardThemeTypeProvider = Provider<BoardThemeType>((ref) {
  return ref.watch(settingsProvider).value?.boardTheme ?? BoardThemeType.classic;
});
