import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:bishop/bishop.dart' as bishop;
import 'package:stockfish/stockfish.dart' as sf;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalysisResult {
  final String bestMove;
  final int eval;

  AnalysisResult({required this.bestMove, required this.eval});
}

final stockfishServiceProvider = Provider<StockfishService>((ref) {
  final service = StockfishService();
  return service;
});

class StockfishService {
  sf.Stockfish? _stockfish;
  bool _useMock = false;
  StreamSubscription? _stdoutSubscription;
  Completer<String>? _bestMoveCompleter;
  Completer<AnalysisResult>? _analysisCompleter;
  int _lastParsedScore = 0;
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
      debugPrint('Stockfish native initialization threw exception, falling back to Bishop Mock Engine: $e');
      _useMock = true;
    }
  }

  void _onStateChanged() {
    if (_stockfish == null) return;
    
    final stateVal = _stockfish!.state.value;
    if (stateVal == sf.StockfishState.ready) {
      try {
        _stockfish!.stdin = 'uci';
        debugPrint('Stockfish native engine is ready.');
      } catch (e) {
        debugPrint('Failed to write initial UCI to Stockfish: $e. Falling back to mock.');
        _useMock = true;
      }
    } else if (stateVal == sf.StockfishState.error) {
      debugPrint('Stockfish state changed to error, falling back to Bishop Mock Engine.');
      _useMock = true;
    }
  }

  void _handleStdout(String line) {
    // Parse bestmove
    if (line.startsWith('bestmove')) {
      final parts = line.split(' ');
      if (parts.length >= 2) {
        final bestMove = parts[1];
        if (_bestMoveCompleter != null && !_bestMoveCompleter!.isCompleted) {
          _bestMoveCompleter!.complete(bestMove);
        }
        if (_analysisCompleter != null && !_analysisCompleter!.isCompleted) {
          _analysisCompleter!.complete(AnalysisResult(bestMove: bestMove, eval: _lastParsedScore));
        }
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
        int parsedScore = 0;
        if (scoreType == 'cp') {
          parsedScore = scoreVal;
        } else if (scoreType == 'mate') {
          // Mate in N moves, map to large values
          parsedScore = scoreVal > 0 ? 10000 : -10000;
        }
        _lastParsedScore = parsedScore;
        _analysisController.add(parsedScore);
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
      debugPrint('Error getting best move from Stockfish: $e. Falling back to mock.');
      return _getMockBestMove(fen, level);
    }
  }

  /// Analyze a position and get the best move and evaluation.
  Future<AnalysisResult> analyzePosition(String fen, {int depth = 14, int level = 10}) async {
    if (!_isReady) {
      return _getMockAnalysis(fen, level);
    }

    try {
      _lastParsedScore = 0;
      _analysisCompleter = Completer<AnalysisResult>();
      
      final skillLevel = ((level - 1) * 2).clamp(0, 20);
      _stockfish!.stdin = 'setoption name Skill Level value $skillLevel';
      _stockfish!.stdin = 'position fen $fen';
      _stockfish!.stdin = 'go depth $depth';

      return await _analysisCompleter!.future.timeout(
        const Duration(seconds: 8),
        onTimeout: () => _getMockAnalysis(fen, level),
      );
    } catch (e) {
      debugPrint('Error analyzing position: $e. Falling back to mock.');
      return _getMockAnalysis(fen, level);
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
      debugPrint('Error writing analysis commands to Stockfish: $e');
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
        debugPrint('Error stopping Stockfish analysis: $e');
      }
    }
  }

  /// Generate mock move using Bishop Engine.
  Future<String> _getMockBestMove(String fen, int level) async {
    // Artificial delay to make it feel like a bot is thinking
    final thinkingTime = Random().nextInt(1000) + 500;
    await Future.delayed(Duration(milliseconds: thinkingTime));

    try {
      return await compute(_runMockSearch, _MockSearchArgs(fen, level));
    } catch (e) {
      debugPrint('Mock engine move generation failed: $e');
      return '';
    }
  }

  Future<AnalysisResult> _getMockAnalysis(String fen, int level) async {
    final thinkingTime = Random().nextInt(200) + 100;
    await Future.delayed(Duration(milliseconds: thinkingTime));

    try {
      return await compute(_runMockAnalysis, _MockAnalysisArgs(fen, level));
    } catch (e) {
      debugPrint('Mock engine analysis failed: $e');
      return AnalysisResult(bestMove: '', eval: 0);
    }
  }


  void dispose() {
    _stdoutSubscription?.cancel();
    _analysisController.close();
    try {
      _stockfish?.dispose();
    } catch (e) {
      debugPrint('Error disposing Stockfish: $e');
    }
  }
}

// Data holder classes and isolate functions for background execution

class _MockSearchArgs {
  final String fen;
  final int level;

  _MockSearchArgs(this.fen, this.level);
}

class _MockAnalysisArgs {
  final String fen;
  final int level;

  _MockAnalysisArgs(this.fen, this.level);
}

String _moveToUciStatic(bishop.Game game, bishop.Move m) {
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

Future<String> _runMockSearch(_MockSearchArgs args) async {
  try {
    final game = bishop.Game(variant: bishop.Variant.standard(), fen: args.fen);
    if (game.gameOver) return '';

    final moves = game.generateLegalMoves();
    if (moves.isEmpty) return '';

    final optimalProb = args.level / 10.0;
    final isOptimal = Random().nextDouble() < optimalProb;

    if (isOptimal) {
      final searchDepth = args.level >= 8 ? 3 : (args.level >= 4 ? 2 : 1);
      final engine = bishop.Engine(game: game);
      final result = await engine.search(maxDepth: searchDepth, timeLimit: 800);
      final move = result.move;
      if (move != null) {
        return _moveToUciStatic(game, move);
      }
    }

    final randomMove = moves[Random().nextInt(moves.length)];
    return _moveToUciStatic(game, randomMove);
  } catch (e) {
    return '';
  }
}

Future<AnalysisResult> _runMockAnalysis(_MockAnalysisArgs args) async {
  try {
    final game = bishop.Game(variant: bishop.Variant.standard(), fen: args.fen);
    if (game.gameOver) {
      int eval = 0;
      if (game.won) {
        eval = -10000;
      }
      return AnalysisResult(bestMove: '', eval: eval);
    }

    final moves = game.generateLegalMoves();
    if (moves.isEmpty) return AnalysisResult(bestMove: '', eval: 0);

    final searchDepth = args.level >= 8 ? 3 : (args.level >= 4 ? 2 : 1);
    final engine = bishop.Engine(game: game);
    final result = await engine.search(maxDepth: searchDepth, timeLimit: 300);
    
    final move = result.move;
    final bestMove = move != null ? _moveToUciStatic(game, move) : '';
    final eval = result.eval ?? game.evaluate(game.turn);

    return AnalysisResult(bestMove: bestMove, eval: eval);
  } catch (e) {
    return AnalysisResult(bestMove: '', eval: 0);
  }
}
