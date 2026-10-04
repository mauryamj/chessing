import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:drift/native.dart';
import 'package:chessing/features/play/board/board_provider.dart';
import 'package:chessing/features/play/board/board_state.dart';
import 'package:chessing/features/play/setup/game_setup_provider.dart';
import 'package:chessing/core/engine/stockfish_service.dart';
import 'package:chessing/core/database/app_database.dart';
import 'package:chessing/core/cache/cache_service.dart';

class MockStockfishService extends Mock implements StockfishService {}

final _levelConfigWhite = GameConfig(
  mode: GameMode.level,
  botLevel: 3,
  playerColor: PlayerColor.white,
  timeControl: TimeControl.blitz5_0,
);

final _levelConfigBlack = GameConfig(
  mode: GameMode.level,
  botLevel: 3,
  playerColor: PlayerColor.black,
  timeControl: TimeControl.blitz5_0,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockStockfishService mockStockfish;
  late AppDatabase inMemoryDb;

  setUp(() {
    mockStockfish = MockStockfishService();
    inMemoryDb = AppDatabase.forTesting(NativeDatabase.memory());

    when(() => mockStockfish.getBestMove(any(), level: any(named: 'level')))
        .thenAnswer((_) async => 'e7e5');
    when(() => mockStockfish.stopAnalysis()).thenReturn(null);
  });

  tearDown(() async {
    await inMemoryDb.close();
  });

  ProviderContainer makeContainer() {
    return ProviderContainer(
      overrides: [
        stockfishServiceProvider.overrideWithValue(mockStockfish),
        databaseProvider.overrideWithValue(inMemoryDb),
        cacheServiceProvider.overrideWithValue(CacheService(inMemoryDb)),
      ],
    );
  }

  group('BoardNotifier initialization', () {
    test('starts in playing state with player as White', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      final state = container.read(boardStateProvider(_levelConfigWhite));
      expect(state.status, GameStatus.playing);
      expect(state.playerColorIndex, 0); // White
      expect(state.isPlayerTurn, true);  // White moves first
      expect(state.isGameOver, false);
      expect(state.moves, isEmpty);
    });

    test('player as Black starts with isPlayerTurn false', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      final state = container.read(boardStateProvider(_levelConfigBlack));
      expect(state.status, GameStatus.playing);
      expect(state.playerColorIndex, 1); // Black
      expect(state.isPlayerTurn, false); // Bot is White and moves first
    });
  });

  group('BoardNotifier resign()', () {
    test('sets status to resigned and records defeat', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      final notifier = container.read(boardStateProvider(_levelConfigWhite).notifier);
      notifier.resign();

      final state = container.read(boardStateProvider(_levelConfigWhite));
      expect(state.status, GameStatus.resigned);
      expect(state.isGameOver, true);
      expect(state.wasDefeat, true);

      // Allow background db save to complete
      await Future<void>.delayed(const Duration(milliseconds: 50));
      final games = await inMemoryDb.getAllGames();
      expect(games.length, 1);
      expect(games.first.result, '0-1'); // White resigned -> Black won
    });

    test('checkmate when it is player turn counts as defeat', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      final baseState = container.read(boardStateProvider(_levelConfigWhite));
      final defeatedState = baseState.copyWith(
        status: GameStatus.checkmate,
        isPlayerTurn: true,
      );
      expect(defeatedState.wasDefeat, true);

      final wonState = baseState.copyWith(
        status: GameStatus.checkmate,
        isPlayerTurn: false,
      );
      expect(wonState.wasDefeat, false);
    });
  });

  group('BoardNotifier playAgain()', () {
    test('resets game state back to initial playing state', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      final notifier = container.read(boardStateProvider(_levelConfigWhite).notifier);
      notifier.resign();
      expect(container.read(boardStateProvider(_levelConfigWhite)).isGameOver, true);

      notifier.playAgain();
      final resetState = container.read(boardStateProvider(_levelConfigWhite));
      expect(resetState.status, GameStatus.playing);
      expect(resetState.moves, isEmpty);
      expect(resetState.isPlayerTurn, true);
    });
  });

  group('BoardNotifier toggleThreatOverlay()', () {
    test('toggles threat overlay flag properly', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      final notifier = container.read(boardStateProvider(_levelConfigWhite).notifier);
      expect(container.read(boardStateProvider(_levelConfigWhite)).threatOverlayEnabled, false);

      notifier.toggleThreatOverlay();
      expect(container.read(boardStateProvider(_levelConfigWhite)).threatOverlayEnabled, true);

      notifier.toggleThreatOverlay();
      expect(container.read(boardStateProvider(_levelConfigWhite)).threatOverlayEnabled, false);
    });
  });
}
