import 'package:square_bishop/square_bishop.dart';

enum GameStatus { playing, checkmate, stalemate, draw, resigned, timeout }

class BoardState {
  final String fen;
  final List<String> moves;
  final List<String> movesSan;
  final bool isPlayerTurn;
  final String? lastMove;
  final GameStatus status;
  final Duration whiteTime;
  final Duration blackTime;
  final SquaresState squaresState;
  final int playerColorIndex; // 0 for White, 1 for Black
  final bool threatOverlayEnabled;
  final List<int> threatSquares; // List of squares (0-63) under threat

  BoardState({
    required this.fen,
    required this.moves,
    required this.movesSan,
    required this.isPlayerTurn,
    this.lastMove,
    required this.status,
    required this.whiteTime,
    required this.blackTime,
    required this.squaresState,
    required this.playerColorIndex,
    this.threatOverlayEnabled = false,
    this.threatSquares = const [],
  });

  BoardState copyWith({
    String? fen,
    List<String>? moves,
    List<String>? movesSan,
    bool? isPlayerTurn,
    String? lastMove,
    GameStatus? status,
    Duration? whiteTime,
    Duration? blackTime,
    SquaresState? squaresState,
    int? playerColorIndex,
    bool? threatOverlayEnabled,
    List<int>? threatSquares,
  }) {
    return BoardState(
      fen: fen ?? this.fen,
      moves: moves ?? this.moves,
      movesSan: movesSan ?? this.movesSan,
      isPlayerTurn: isPlayerTurn ?? this.isPlayerTurn,
      lastMove: lastMove ?? this.lastMove,
      status: status ?? this.status,
      whiteTime: whiteTime ?? this.whiteTime,
      blackTime: blackTime ?? this.blackTime,
      squaresState: squaresState ?? this.squaresState,
      playerColorIndex: playerColorIndex ?? this.playerColorIndex,
      threatOverlayEnabled: threatOverlayEnabled ?? this.threatOverlayEnabled,
      threatSquares: threatSquares ?? this.threatSquares,
    );
  }
}
