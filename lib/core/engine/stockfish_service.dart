import 'dart:async';
import 'dart:math';
import 'package:bishop/bishop.dart' as bishop;
import 'package:stockfish/stockfish.dart' as sf;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stockfishServiceProvider = Provider.autoDispose<StockfishService>((ref) {
  final service = StockfishService();
  ref.onDispose(() => service.dispose());
  return service;
});

class StockfishService {
  sf.Stockfish? _stockfish;
  bool _useMock = false;
  StreamSubscription? _stdoutSubscription;
  Completer<String>? _bestMoveCompleter;
  final _analysisController = StreamController<int>.broadcast();

  StockfishService() {
    _initEngine();
  }

  bool get _isReady =>
      !_useMock &&
      _stockfish != null &&
      _stockfish!.state.value == sf.StockfishState.ready;

  void _initEngine() {
    try {
      _stockfish = sf.Stockfish();
      _stdoutSubscription = _stockfish!.stdout.listen(_handleStdout);
      
      // Listen for initialization success or failure
      _stockfish!.state.addListener(_onStateChanged);
      
      // Trigger initial check if already ready
      _onStateChanged();
    } catch (e) {
      print('Stockfish native initialization threw exception, falling back to Bishop Mock Engine: $e');
      _useMock = true;
    }
  }

  void _onStateChanged() {
    if (_stockfish == null) return;
    
    final stateVal = _stockfish!.state.value;
    if (stateVal == sf.StockfishState.ready) {
      try {
        _stockfish!.stdin = 'uci';
        print('Stockfish native engine is ready.');
      } catch (e) {
        print('Failed to write initial UCI to Stockfish: $e. Falling back to mock.');
        _useMock = true;
      }
    } else if (stateVal == sf.StockfishState.error) {
      print('Stockfish state changed to error, falling back to Bishop Mock Engine.');
      _useMock = true;
    }
  }

  void _handleStdout(String line) {
    // Parse bestmove
    if (line.startsWith('bestmove')) {
      final parts = line.split(' ');
      if (parts.length >= 2 && _bestMoveCompleter != null && !_bestMoveCompleter!.isCompleted) {
        _bestMoveCompleter!.complete(parts[1]);
      }
    }
    // Parse score for analysisStream (e.g., "info depth 10 seldepth 12 score cp 34 ...")
    else if (line.startsWith('info') && line.contains('score')) {
      final parts = line.split(' ');
      final scoreIndex = parts.indexOf('score');
      if (scoreIndex != -1 && scoreIndex + 2 < parts.length) {
        final scoreType = parts[scoreIndex + 1]; // cp or mate
        final scoreValueStr = parts[scoreIndex + 2];
        final scoreVal = int.tryParse(scoreValueStr) ?? 0;
        if (scoreType == 'cp') {
          _analysisController.add(scoreVal);
        } else if (scoreType == 'mate') {
          // Mate in N moves, map to large values
          _analysisController.add(scoreVal > 0 ? 10000 : -10000);
        }
      }
    }
  }

  /// Get the best move for a position.
  Future<String> getBestMove(String fen, {int depth = 15, int level = 5}) async {
    if (!_isReady) {
      return _getMockBestMove(fen, level);
    }

    try {
      _bestMoveCompleter = Completer<String>();
      // Map level 1-10 to UCI Skill Level 0-20
      final skillLevel = ((level - 1) * 2).clamp(0, 20);
      _stockfish!.stdin = 'setoption name Skill Level value $skillLevel';
      _stockfish!.stdin = 'position fen $fen';
      _stockfish!.stdin = 'go depth $depth';

      // Fallback timeout in case engine hangs
      return await _bestMoveCompleter!.future.timeout(
        const Duration(seconds: 8),
        onTimeout: () => _getMockBestMove(fen, level),
      );
    } catch (e) {
      print('Error getting best move from Stockfish: $e. Falling back to mock.');
      return _getMockBestMove(fen, level);
    }
  }

  /// Broadcast evaluation updates (in centipawns, from perspective of white).
  Stream<int> analysisStream(String fen) {
    if (!_isReady) {
      // Mock evaluation stream
      final controller = StreamController<int>();
      try {
        final game = bishop.Game(variant: bishop.Variant.standard(), fen: fen);
        // Initial eval
        final eval = game.evaluate(0); // 0 is White
        controller.add(eval);
        
        // Yield small variations to look active
        var count = 0;
        Timer.periodic(const Duration(milliseconds: 500), (t) {
          if (controller.isClosed) {
            t.cancel();
            return;
          }
          final variation = Random().nextInt(21) - 10; // -10 to +10
          controller.add(eval + variation);
          count++;
          if (count >= 4) {
            t.cancel();
            controller.close();
          }
        });
      } catch (e) {
        controller.add(0);
        controller.close();
      }
      return controller.stream;
    }

    // Set position and run infinite analysis
    try {
      _stockfish!.stdin = 'position fen $fen';
      _stockfish!.stdin = 'go infinite';
    } catch (e) {
      print('Error writing analysis commands to Stockfish: $e');
    }

    // Return the broadcast stream (the subscriber can cancel to stop listening)
    return _analysisController.stream;
  }

  /// Stop the engine analysis.
  void stopAnalysis() {
    if (_isReady) {
      try {
        _stockfish!.stdin = 'stop';
      } catch (e) {
        print('Error stopping Stockfish analysis: $e');
      }
    }
  }

  /// Generate mock move using Bishop Engine.
  Future<String> _getMockBestMove(String fen, int level) async {
    // Artificial delay to make it feel like a bot is thinking
    final thinkingTime = Random().nextInt(1000) + 500;
    await Future.delayed(Duration(milliseconds: thinkingTime));

    try {
      final game = bishop.Game(variant: bishop.Variant.standard(), fen: fen);
      if (game.gameOver) return '';

      final moves = game.generateLegalMoves();
      if (moves.isEmpty) return '';

      // Map level (1-10) to search depth and random play probability
      // Level 1: 10% optimal, 90% random
      // Level 10: 100% optimal (Depth 3)
      final optimalProb = level / 10.0;
      final isOptimal = Random().nextDouble() < optimalProb;

      if (isOptimal) {
        final searchDepth = level >= 8 ? 3 : (level >= 4 ? 2 : 1);
        final engine = bishop.Engine(game: game);
        final result = await engine.search(maxDepth: searchDepth, timeLimit: 800);
        if (result.move != null) {
          return _moveToUci(game, result.move!);
        }
      }

      // Fallback/Random move
      final randomMove = moves[Random().nextInt(moves.length)];
      return _moveToUci(game, randomMove);
    } catch (e) {
      print('Mock engine move generation failed: $e');
      return '';
    }
  }

  String _moveToUci(bishop.Game game, bishop.Move m) {
    final fromStr = game.size.squareName(m.from);
    final toStr = game.size.squareName(m.to);
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

  void dispose() {
    _stdoutSubscription?.cancel();
    _analysisController.close();
    try {
      _stockfish?.dispose();
    } catch (e) {
      print('Error disposing Stockfish: $e');
    }
  }
}
