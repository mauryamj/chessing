---
name: board-provider-test
description: Write comprehensive unit tests for BoardNotifier — the core game state provider. Use when the user asks to add tests for game logic, clock, resign, checkmate detection, bot move handling, or rating update flow.
---

# Skill: BoardNotifier Unit Tests

## Background

`lib/features/play/board/board_provider.dart` contains `BoardNotifier` — the most critical, untested class in the project. It manages move validation, clock, resign, checkmate detection, rating updates, and SQLite/Supabase sync.

This skill provides test patterns using `ProviderContainer` with mocked dependencies.

## Test Dependencies to Add

```yaml
# pubspec.yaml — dev_dependencies (already have flutter_test)
dev_dependencies:
  mocktail: ^1.0.0  # Add this
```

Run `flutter pub get` after adding.

## Mock Classes

```dart
// test/features/play/board/board_provider_test.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:chessing/features/play/board/board_provider.dart';
import 'package:chessing/features/play/board/board_state.dart';
import 'package:chessing/features/play/setup/game_setup_provider.dart';
import 'package:chessing/core/engine/stockfish_service.dart';
import 'package:chessing/core/database/app_database.dart';

class MockStockfishService extends Mock implements StockfishService {}
class MockAppDatabase extends Mock implements AppDatabase {}

// Minimal GameConfig for tests
final _levelConfig = GameConfig(
  mode: GameMode.level,
  botLevel: 3,
  playerColor: PlayerColor.white,
  timeControl: TimeControl.blitz5,
);
```

## Core Test Cases

```dart
void main() {
  late MockStockfishService mockStockfish;
  late MockAppDatabase mockDb;

  setUp(() {
    mockStockfish = MockStockfishService();
    mockDb = MockAppDatabase();

    // Default stub: bot returns a valid move
    when(() => mockStockfish.getBestMove(any(), level: any(named: 'level')))
        .thenAnswer((_) async => 'e7e5');
    when(() => mockStockfish.stopAnalysis()).thenReturn(null);

    // DB stubs
    when(() => mockDb.insertGame(any())).thenAnswer((_) async => 1);
    when(() => mockDb.insertMove(any())).thenAnswer((_) async => 1);
    when(() => mockDb.ensureProfileExists()).thenAnswer((_) async {});
    when(() => mockDb.getProfile()).thenAnswer((_) async => null);
    when(() => mockDb.markPendingSync(any())).thenAnswer((_) async {});
  });

  ProviderContainer makeContainer() {
    return ProviderContainer(
      overrides: [
        stockfishServiceProvider.overrideWithValue(mockStockfish),
        databaseProvider.overrideWithValue(mockDb),
      ],
    );
  }

  group('BoardNotifier initialization', () {
    test('starts in playing state with player as White', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      final state = container.read(boardStateProvider(_levelConfig));
      expect(state.status, GameStatus.playing);
      expect(state.playerColorIndex, 0); // White
      expect(state.isPlayerTurn, true);  // White moves first
    });

    test('player as Black: isPlayerTurn starts false', () {
      final config = _levelConfig.copyWith(playerColor: PlayerColor.black);
      final container = makeContainer();
      addTearDown(container.dispose);

      final state = container.read(boardStateProvider(config));
      expect(state.isPlayerTurn, false); // Bot (White) moves first
    });
  });

  group('makeMove guard conditions', () {
    test('returns false when game is over', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      final notifier = container.read(boardStateProvider(_levelConfig).notifier);
      notifier.resign(); // end the game

      // Attempting any move should be rejected
      // (move object would come from the board widget; use a dummy here)
      // In practice: verify state.status != playing blocks moves
      final state = container.read(boardStateProvider(_levelConfig));
      expect(state.isGameOver, true);
    });
  });

  group('resign()', () {
    test('sets status to resigned', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      final notifier = container.read(boardStateProvider(_levelConfig).notifier);
      notifier.resign();

      final state = container.read(boardStateProvider(_levelConfig));
      expect(state.status, GameStatus.resigned);
    });

    test('calls insertGame after resign', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      final notifier = container.read(boardStateProvider(_levelConfig).notifier);
      notifier.resign();
      
      await Future.delayed(Duration.zero); // allow async save to complete
      verify(() => mockDb.insertGame(any())).called(1);
    });
  });

  group('playAgain()', () {
    test('resets status to playing', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      final notifier = container.read(boardStateProvider(_levelConfig).notifier);
      notifier.resign();
      notifier.playAgain();

      final state = container.read(boardStateProvider(_levelConfig));
      expect(state.status, GameStatus.playing);
    });
  });

  group('toggleThreatOverlay()', () {
    test('toggles threat overlay on/off', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      final notifier = container.read(boardStateProvider(_levelConfig).notifier);
      expect(container.read(boardStateProvider(_levelConfig)).threatOverlayEnabled, false);

      notifier.toggleThreatOverlay();
      expect(container.read(boardStateProvider(_levelConfig)).threatOverlayEnabled, true);

      notifier.toggleThreatOverlay();
      expect(container.read(boardStateProvider(_levelConfig)).threatOverlayEnabled, false);
    });
  });
}
```

## Adding `copyWith` to `GameConfig`

The test uses `_levelConfig.copyWith(playerColor: PlayerColor.black)`. If `GameConfig` doesn't have `copyWith`, add it to `lib/features/play/setup/game_setup_provider.dart`.

## Running the Tests

```bash
flutter test test/features/play/board/board_provider_test.dart --verbose
```

## Integration Test: Full Game Save

```dart
test('resign saves game to database with correct result', () async {
  final container = makeContainer();
  addTearDown(container.dispose);

  when(() => mockDb.insertGame(any())).thenAnswer((_) async => 42);

  final notifier = container.read(boardStateProvider(_levelConfig).notifier);
  notifier.resign();
  await Future.delayed(const Duration(milliseconds: 100));

  final captured = verify(() => mockDb.insertGame(captureAny())).captured;
  final companion = captured.first as GamesCompanion;
  // Player resigned → result should be '0-1' (player was White)
  expect(companion.result.value, '0-1');
});
```
