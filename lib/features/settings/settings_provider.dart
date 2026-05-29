import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ────────────────────────────────────────────────────────────────────────────
// Board-theme enum
// ────────────────────────────────────────────────────────────────────────────

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

// ────────────────────────────────────────────────────────────────────────────
// Settings model
// ────────────────────────────────────────────────────────────────────────────

class AppSettings {
  final ThemeMode themeMode;
  final BoardThemeType boardTheme;
  final bool soundEnabled;
  final bool hapticsEnabled;

  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.boardTheme = BoardThemeType.classic,
    this.soundEnabled = true,
    this.hapticsEnabled = true,
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    BoardThemeType? boardTheme,
    bool? soundEnabled,
    bool? hapticsEnabled,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      boardTheme: boardTheme ?? this.boardTheme,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// SharedPreferences keys
// ────────────────────────────────────────────────────────────────────────────

const _kThemeMode = 'settings_theme_mode';
const _kBoardTheme = 'settings_board_theme';
const _kSound = 'settings_sound';
const _kHaptics = 'settings_haptics';

// ────────────────────────────────────────────────────────────────────────────
// Notifier
// ────────────────────────────────────────────────────────────────────────────

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
    final sound = _prefs.getBool(_kSound) ?? true;
    final haptics = _prefs.getBool(_kHaptics) ?? true;

    return AppSettings(
      themeMode: ThemeMode.values[themeModeIndex],
      boardTheme: BoardThemeType.values[boardThemeIndex],
      soundEnabled: sound,
      hapticsEnabled: haptics,
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

  Future<void> setSound(bool enabled) async {
    await _prefs.setBool(_kSound, enabled);
    state = AsyncData(state.value!.copyWith(soundEnabled: enabled));
  }

  Future<void> setHaptics(bool enabled) async {
    await _prefs.setBool(_kHaptics, enabled);
    state = AsyncData(state.value!.copyWith(hapticsEnabled: enabled));
  }
}

final settingsProvider = AsyncNotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);

/// Convenience provider: just the ThemeMode (for MaterialApp).
final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(settingsProvider).value?.themeMode ?? ThemeMode.system;
});

/// Convenience provider: just the BoardThemeType.
final boardThemeTypeProvider = Provider<BoardThemeType>((ref) {
  return ref.watch(settingsProvider).value?.boardTheme ?? BoardThemeType.classic;
});
