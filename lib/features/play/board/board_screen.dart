import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:squares/squares.dart' as sq;
import 'board_provider.dart';
import 'board_state.dart';
import '../setup/game_setup_provider.dart';
import 'widgets/clock_widget.dart';
import 'widgets/captured_pieces_bar.dart';
import 'widgets/material_diff_bar.dart';
import 'widgets/legal_moves_overlay.dart';
import '../../../app/theme.dart';
import '../../settings/settings_provider.dart';
import 'widgets/game_over_overlay.dart';

class BoardScreen extends ConsumerWidget {
  final Map<String, dynamic>? config;

  const BoardScreen({super.key, this.config});

  sq.BoardTheme _getBoardTheme(BuildContext context, WidgetRef ref) {
    final boardThemeType = ref.watch(boardThemeTypeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ChessBoardTheme ext;
    switch (boardThemeType) {
      case BoardThemeType.wood:
        ext = isDark ? ChessBoardTheme.woodDark : ChessBoardTheme.woodLight;
        break;
      case BoardThemeType.neon:
        ext = isDark ? ChessBoardTheme.neonDark : ChessBoardTheme.neonLight;
        break;
      case BoardThemeType.minimal:
        ext = isDark ? ChessBoardTheme.minimalDark : ChessBoardTheme.minimalLight;
        break;
      case BoardThemeType.classic:
        ext = Theme.of(context).extension<ChessBoardTheme>() ??
            (isDark ? ChessBoardTheme.classicDark : ChessBoardTheme.classicLight);
        break;
    }
    return sq.BoardTheme(
      lightSquare: ext.lightSquareColor,
      darkSquare: ext.darkSquareColor,
      check: ext.checkSquareColor,
      checkmate: Colors.orange,
      previous: ext.lastMoveDestColor,
      selected: ext.selectedSquareColor,
      premove: const Color(0x807B56B3),
    );
  }



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configJson = config ?? {};
    final gameConfig = GameConfig.fromJson(configJson);
    final boardState = ref.watch(boardStateProvider(gameConfig));
    final notifier = ref.read(boardStateProvider(gameConfig).notifier);
    final theme = Theme.of(context);

    final isPlayerWhite = boardState.playerColorIndex == 0;
    
    // Determine active clock
    final isWhiteActive = boardState.status == GameStatus.playing && boardState.squaresState.board.turn == 0;
    final isBlackActive = boardState.status == GameStatus.playing && boardState.squaresState.board.turn == 1;

    final playerClockActive = isPlayerWhite ? isWhiteActive : isBlackActive;
    final botClockActive = isPlayerWhite ? isBlackActive : isWhiteActive;

    final playerDuration = isPlayerWhite ? boardState.whiteTime : boardState.blackTime;
    final botDuration = isPlayerWhite ? boardState.blackTime : boardState.whiteTime;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      if (boardState.status == GameStatus.playing) {
                        // Confirm resignation before leaving
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Resign Game?'),
                            content: const Text('Leaving now will count as a resignation. Are you sure?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  notifier.resign();
                                  context.pop();
                                },
                                child: const Text('Resign & Exit', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      } else {
                        context.pop();
                      }
                    },
                  ),
                  Text(
                    gameConfig.mode == GameMode.timed
                        ? 'Timed Match (${gameConfig.timeControl.label})'
                        : 'Match vs Bot Level ${gameConfig.botLevel}',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 48), // Spacer to balance back button
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // TOP PLAYER (BOT)
                    Card(
                      elevation: botClockActive ? 2 : 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: botClockActive
                            ? BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.5), width: 1)
                            : BorderSide(color: theme.dividerColor.withValues(alpha: 0.1), width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                              child: Icon(Icons.computer, color: theme.colorScheme.primary),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Stockfish Bot',
                                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Difficulty Level ${gameConfig.botLevel}',
                                    style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        CapturedPiecesBar(
                                          boardSymbols: boardState.squaresState.board.board,
                                          forWhite: !isPlayerWhite,
                                        ),
                                        const SizedBox(width: 4),
                                        MaterialDiffBar(
                                          boardSymbols: boardState.squaresState.board.board,
                                          forWhite: !isPlayerWhite,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (gameConfig.mode == GameMode.timed)
                              ClockWidget(
                                duration: botDuration,
                                isActive: botClockActive,
                                label: 'Bot Time',
                              ),
                          ],
                        ),
                      ),
                    ),

                    // CHESSBOARD CONTAINER
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: sq.BoardController(
                          state: boardState.squaresState.board,
                          playState: boardState.squaresState.state,
                          pieceSet: sq.PieceSet.merida(),
                          theme: _getBoardTheme(context, ref),
                          size: boardState.squaresState.size,
                          moves: boardState.squaresState.moves,
                          markerTheme: legalMovesMarkerTheme,
                          onMove: (move) => notifier.makeMove(move),
                          draggable: boardState.status == GameStatus.playing,
                          overlays: [
                            // Threat Overlay rendering
                            if (boardState.threatOverlayEnabled)
                              IgnorePointer(
                                child: sq.BoardBuilder.index(
                                  size: boardState.squaresState.size,
                                  orientation: boardState.squaresState.board.orientation,
                                  builder: (index, squareSize) {
                                    if (boardState.threatSquares.contains(index)) {
                                      return Center(
                                        child: Container(
                                          width: squareSize * 0.35,
                                          height: squareSize * 0.35,
                                          decoration: BoxDecoration(
                                            color: Colors.red.withValues(alpha: 0.35),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.red,
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    // BOTTOM PLAYER (YOU)
                    Card(
                      elevation: playerClockActive ? 2 : 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: playerClockActive
                            ? BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.5), width: 1)
                            : BorderSide(color: theme.dividerColor.withValues(alpha: 0.1), width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                              child: Icon(Icons.person, color: theme.colorScheme.primary),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'You',
                                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    isPlayerWhite ? 'Playing as White' : 'Playing as Black',
                                    style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        CapturedPiecesBar(
                                          boardSymbols: boardState.squaresState.board.board,
                                          forWhite: isPlayerWhite,
                                        ),
                                        const SizedBox(width: 4),
                                        MaterialDiffBar(
                                          boardSymbols: boardState.squaresState.board.board,
                                          forWhite: isPlayerWhite,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (gameConfig.mode == GameMode.timed)
                              ClockWidget(
                                duration: playerDuration,
                                isActive: playerClockActive,
                                label: 'Your Time',
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Controls/Actions bar
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0, top: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Threat HUD toggle button
                  Semantics(
                    label: boardState.threatOverlayEnabled
                        ? 'Threat overlay enabled, tap to disable'
                        : 'Threat overlay disabled, tap to enable',
                    button: true,
                    excludeSemantics: true,
                    child: ElevatedButton.icon(
                      onPressed: notifier.toggleThreatOverlay,
                      icon: Icon(
                        boardState.threatOverlayEnabled ? Icons.shield : Icons.shield_outlined,
                        color: boardState.threatOverlayEnabled ? Colors.red : theme.hintColor,
                      ),
                      label: Text(
                        'Threat HUD',
                        style: TextStyle(
                          color: boardState.threatOverlayEnabled ? Colors.red : theme.textTheme.bodyMedium?.color,
                          fontWeight: boardState.threatOverlayEnabled ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 1,
                        backgroundColor: boardState.threatOverlayEnabled
                            ? Colors.red.withValues(alpha: 0.08)
                            : theme.cardTheme.color,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),

                  // Resign / Back button
                  if (boardState.status == GameStatus.playing)
                    Semantics(
                      label: 'Resign the current game',
                      button: true,
                      excludeSemantics: true,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Resign?'),
                              content: const Text('Are you sure you want to resign the game?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    notifier.resign();
                                  },
                                  child: const Text('Resign', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.flag, color: Colors.red),
                        label: const Text('Resign', style: TextStyle(color: Colors.red)),
                        style: ElevatedButton.styleFrom(
                          elevation: 1,
                          backgroundColor: theme.cardTheme.color,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    )
                  else
                    Semantics(
                      label: 'Return to setup menu',
                      button: true,
                      excludeSemantics: true,
                      child: ElevatedButton.icon(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.exit_to_app),
                        label: const Text('Back to Menu'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        if (boardState.isGameOver)
          GameOverOverlay(
            state: boardState,
            onPlayAgain: () => notifier.playAgain(),
            onChangeSettings: () => context.go('/setup'),
            onReview: () {
              if (boardState.savedLocalGameId != null) {
                context.push('/review/${boardState.savedLocalGameId}');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Game review not ready yet.')),
                );
              }
            },
          ),
      ],
    ),
  ),
);
  }
}
