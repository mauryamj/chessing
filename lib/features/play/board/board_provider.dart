import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bishop/bishop.dart' as bishop;
import 'package:square_bishop/square_bishop.dart';
import 'package:squares/squares.dart' as sq;
import 'package:drift/drift.dart' show Value;
import 'package:flutter/services.dart';
import '../setup/game_setup_provider.dart';
import '../../settings/settings_provider.dart';
import 'board_state.dart';
import '../../../core/engine/stockfish_service.dart';
import '../../../core/engine/rating_service.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/daos/profile_dao.dart';
import '../../../core/database/daos/games_dao.dart';
import '../../../core/supabase/supabase_client.dart';
import '../../../core/supabase/repositories/profile_repository.dart';
import '../../../core/supabase/sync/sync_service.dart';

class BoardNotifier extends StateNotifier<BoardState> {
  final GameConfig config;
  final Ref ref;
  late final bishop.Game _game;
  Timer? _clockTimer;
  bool _isBotThinking = false;
  late final int _playerColorIndex; // 0 for White, 1 for Black

  BoardNotifier({required this.config, required this.ref})
      : super(BoardState(
          fen: '',
          moves: [],
          movesSan: [],
          isPlayerTurn: false,
          status: GameStatus.playing,
          whiteTime: Duration.zero,
          blackTime: Duration.zero,
          squaresState: SquaresState(
            player: 0,
            state: sq.PlayState.observing,
            size: const sq.BoardSize(8, 8),
            board: const sq.BoardState(board: [], turn: 0),
            moves: const [],
          ),
          playerColorIndex: 0,
          threatSquares: const [],
        )) {
    _initializeGame();
  }

  void _initializeGame() {
    _game = bishop.Game(variant: bishop.Variant.standard());

    // Determine player color
    if (config.playerColor == PlayerColor.random) {
      _playerColorIndex = Random().nextBool() ? 0 : 1;
    } else {
      _playerColorIndex = config.playerColor == PlayerColor.white ? 0 : 1;
    }

    final initialWhiteTime = config.mode == GameMode.timed
        ? config.timeControl.duration
        : Duration.zero;
    final initialBlackTime = config.mode == GameMode.timed
        ? config.timeControl.duration
        : Duration.zero;

    state = BoardState(
      fen: _game.fen,
      moves: [],
      movesSan: [],
      isPlayerTurn: _game.turn == _playerColorIndex,
      status: GameStatus.playing,
      whiteTime: initialWhiteTime,
      blackTime: initialBlackTime,
      squaresState: _game.squaresState(_playerColorIndex),
      playerColorIndex: _playerColorIndex,
      threatSquares: _calculateThreatSquares(),
    );

    if (config.mode == GameMode.timed) {
      _startClock();
    }

    // If bot plays first (player is Black)
    if (!state.isPlayerTurn) {
      _triggerBotMove();
    }
  }

  void _startClock() {
    _clockTimer?.cancel();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.status != GameStatus.playing) return;

      if (_game.turn == 0) {
        // White turn
        final newTime = state.whiteTime - const Duration(seconds: 1);
        if (newTime <= Duration.zero) {
          _handleTimeout(0);
        } else {
          state = state.copyWith(whiteTime: newTime);
          if (_playerColorIndex == 0 && newTime.inSeconds <= 10) {
            _triggerClockWarning();
          }
        }
      } else {
        // Black turn
        final newTime = state.blackTime - const Duration(seconds: 1);
        if (newTime <= Duration.zero) {
          _handleTimeout(1);
        } else {
          state = state.copyWith(blackTime: newTime);
          if (_playerColorIndex == 1 && newTime.inSeconds <= 10) {
            _triggerClockWarning();
          }
        }
      }
    });
  }

  void _handleTimeout(int losingColor) {
    _clockTimer?.cancel();
    state = state.copyWith(
      status: GameStatus.timeout,
      whiteTime: losingColor == 0 ? Duration.zero : state.whiteTime,
      blackTime: losingColor == 1 ? Duration.zero : state.blackTime,
    );
    _saveGameToDatabase();
  }

  /// Make a player move.
  bool makeMove(sq.Move move) {
    if (state.status != GameStatus.playing || !state.isPlayerTurn || _isBotThinking) {
      return false;
    }

    // Convert move to UCI/SAN representation before applying
    final bishopMove = _game.bishopMove(move);
    if (bishopMove == null) return false;
    
    final uci = _moveToUci(bishopMove);
    final san = _game.toSan(bishopMove);
    final isCapture = bishopMove.capture;

    final success = _game.makeSquaresMove(move);
    if (!success) return false;

    _triggerFeedback(isCapture: isCapture, isCheck: _game.inCheck);

    // Increment clock if timed mode has increment
    Duration newWhiteTime = state.whiteTime;
    Duration newBlackTime = state.blackTime;
    if (config.mode == GameMode.timed) {
      final inc = Duration(seconds: config.timeControl.incrementSeconds);
      if (_playerColorIndex == 0) {
        newWhiteTime += inc;
      } else {
        newBlackTime += inc;
      }
    }

    state = state.copyWith(
      fen: _game.fen,
      moves: [...state.moves, uci],
      movesSan: [...state.movesSan, san],
      isPlayerTurn: false,
      lastMove: uci,
      whiteTime: newWhiteTime,
      blackTime: newBlackTime,
      squaresState: _game.squaresState(_playerColorIndex),
      threatSquares: _calculateThreatSquares(),
    );

    _checkGameOver();

    if (state.status == GameStatus.playing) {
      _triggerBotMove();
    }

    return true;
  }

  Future<void> _triggerBotMove() async {
    _isBotThinking = true;
    try {
      final service = ref.read(stockfishServiceProvider);
      final botMoveUci = await service.getBestMove(
        _game.fen,
        level: config.botLevel,
      );

      if (botMoveUci.isEmpty || state.status != GameStatus.playing) {
        return;
      }

      // Parse and apply bot move
      final sqMove = _game.squaresSize.moveFromAlgebraic(botMoveUci);
      final bishopMove = _game.bishopMove(sqMove);
      final san = bishopMove != null ? _game.toSan(bishopMove) : '';
      final isCapture = bishopMove?.capture ?? false;

      _game.makeSquaresMove(sqMove);

      _triggerFeedback(isCapture: isCapture, isCheck: _game.inCheck);

      // Increment clock for bot
      Duration newWhiteTime = state.whiteTime;
      Duration newBlackTime = state.blackTime;
      if (config.mode == GameMode.timed) {
        final inc = Duration(seconds: config.timeControl.incrementSeconds);
        if (_playerColorIndex == 1) {
          // Bot is White
          newWhiteTime += inc;
        } else {
          // Bot is Black
          newBlackTime += inc;
        }
      }

      state = state.copyWith(
        fen: _game.fen,
        moves: [...state.moves, botMoveUci],
        movesSan: [...state.movesSan, san],
        isPlayerTurn: true,
        lastMove: botMoveUci,
        whiteTime: newWhiteTime,
        blackTime: newBlackTime,
        squaresState: _game.squaresState(_playerColorIndex),
        threatSquares: _calculateThreatSquares(),
      );

      _checkGameOver();
    } catch (e) {
      debugPrint('Error during bot move execution: $e');
    } finally {
      _isBotThinking = false;
    }
  }

  void _checkGameOver() {
    if (_game.gameOver) {
      _clockTimer?.cancel();
      if (_game.drawn) {
        state = state.copyWith(status: GameStatus.draw);
      } else if (_game.won) {
        state = state.copyWith(status: GameStatus.checkmate);
      }
      _saveGameToDatabase();
    }
  }

  void resign() {
    if (state.status != GameStatus.playing) return;
    _clockTimer?.cancel();
    state = state.copyWith(status: GameStatus.resigned);
    _saveGameToDatabase();
  }

  void toggleThreatOverlay() {
    state = state.copyWith(threatOverlayEnabled: !state.threatOverlayEnabled);
  }

  List<int> _calculateThreatSquares() {
    final opponent = 1 - _playerColorIndex;
    final threatSquares = <int>[];
    const sqSize = sq.BoardSize.standard;
    for (int i = 0; i < 64; i++) {
      final name = sqSize.squareName(i);
      final bpSquareIndex = _game.size.squareNumber(name);
      if (_game.isAttacked(bpSquareIndex, opponent)) {
        threatSquares.add(i);
      }
    }
    return threatSquares;
  }

  String _moveToUci(bishop.Move m) {
    final fromStr = _game.size.squareName(m.from);
    final toStr = _game.size.squareName(m.to);
    String promoStr = '';
    if (m.promotion && m.promoPiece != null) {
      switch (m.promoPiece) {
        case 2:
          promoStr = 'n';
          break;
        case 3:
          promoStr = 'b';
          break;
        case 4:
          promoStr = 'r';
          break;
        case 5:
          promoStr = 'q';
          break;
      }
    }
    return '$fromStr$toStr$promoStr';
  }

  Future<void> _saveGameToDatabase() async {
    try {
      final db = ref.read(databaseProvider);

      // Determine result string
      String resultStr = '1/2-1/2';
      bool playerWon = false;
      bool isDraw = false;

      if (state.status == GameStatus.checkmate) {
        // The player whose turn it is LOST
        final winnerColor = _game.turn == 0 ? 1 : 0; // opposite of who is to move
        playerWon = winnerColor == _playerColorIndex;
        if (_game.turn == 0) {
          resultStr = '0-1';
        } else {
          resultStr = '1-0';
        }
      } else if (state.status == GameStatus.resigned) {
        playerWon = false; // player resigned
        resultStr = _playerColorIndex == 0 ? '0-1' : '1-0';
      } else if (state.status == GameStatus.timeout) {
        final losingColor = state.whiteTime == Duration.zero ? 0 : 1;
        playerWon = losingColor != _playerColorIndex;
        resultStr = losingColor == 0 ? '0-1' : '1-0';
      } else {
        isDraw = true;
      }

      final gamesCompanion = GamesCompanion.insert(
        pgn: _game.pgn(),
        result: resultStr,
        mode: config.mode.name,
        botLevel: config.mode == GameMode.level
            ? Value(config.botLevel)
            : const Value.absent(),
        timeControlSeconds: config.mode == GameMode.timed
            ? Value(config.timeControl.duration.inSeconds)
            : const Value.absent(),
        playedAt: DateTime.now(),
        playerColorIndex: Value(_playerColorIndex),
      );

      final gameId = await db.insertGame(gamesCompanion);

      // Save individual moves
      for (int i = 0; i < state.moves.length; i++) {
        final movesCompanion = MovesCompanion.insert(
          gameId: gameId,
          ply: i,
          uci: state.moves[i],
          san: state.movesSan[i],
        );
        await db.insertMove(movesCompanion);
      }

      // --- Elo rating update ---
      await db.ensureProfileExists();
      final profileData = await db.getProfile();
      if (profileData != null) {
        final botLevel = config.botLevel.clamp(1, 10);
        final botElo = RatingService.botElo(botLevel);
        final score = playerWon ? 1.0 : (isDraw ? 0.5 : 0.0);
        final newRating = RatingService.calculate(
          playerRating: profileData.currentRating,
          opponentRating: botElo,
          score: score,
        );
        await db.updateRating(
          newRating: newRating,
          isWin: playerWon,
          isDraw: isDraw,
        );
        debugPrint('Rating updated: ${profileData.currentRating} → $newRating');
      }

      // Supabase syncing hook
      try {
        final profileDataAfter = await db.getProfile();
        final remoteUser = supabase.auth.currentUser;
        if (remoteUser != null && profileDataAfter != null) {
          // Update profile stats remotely
          await ProfileRepository().updateStats(
            userId: remoteUser.id,
            currentRating: profileDataAfter.currentRating,
            peakRating: profileDataAfter.peakRating,
            gamesPlayed: profileDataAfter.gamesPlayed,
            wins: profileDataAfter.wins,
            draws: profileDataAfter.draws,
            losses: profileDataAfter.losses,
          );
          // Push game to remote DB
          await ref.read(syncServiceProvider).pushGame(gameId);
        } else {
          // Offline or guest mode, mark as pending sync
          await db.markPendingSync(gameId);
        }
      } catch (syncError) {
        debugPrint('Failed to sync game/stats remotely: $syncError');
        await db.markPendingSync(gameId);
      }

      debugPrint(
          'Game and moves saved to SQLite. GameID: $gameId');
    } catch (e) {
      debugPrint('Error saving game to SQLite database: $e');
    }
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  void _triggerFeedback({required bool isCapture, required bool isCheck}) {
    final settings = ref.read(settingsProvider).value;
    final soundEnabled = settings?.soundEnabled ?? true;
    final hapticsEnabled = settings?.hapticsEnabled ?? true;

    if (hapticsEnabled) {
      if (isCheck) {
        HapticFeedback.heavyImpact();
      } else if (isCapture) {
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.lightImpact();
      }
    }

    if (soundEnabled) {
      if (isCheck) {
        SystemSound.play(SystemSoundType.alert);
      } else {
        SystemSound.play(SystemSoundType.click);
      }
    }
  }

  void _triggerClockWarning() {
    final settings = ref.read(settingsProvider).value;
    final soundEnabled = settings?.soundEnabled ?? true;
    final hapticsEnabled = settings?.hapticsEnabled ?? true;

    if (hapticsEnabled) {
      HapticFeedback.lightImpact();
    }
    if (soundEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
  }
}

// Family provider to instantiate BoardNotifier with dynamic config
final boardStateProvider =
    StateNotifierProvider.family<BoardNotifier, BoardState, GameConfig>((ref, config) {
  return BoardNotifier(config: config, ref: ref);
});
