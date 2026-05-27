import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/play/setup/game_setup_screen.dart';
import '../features/play/board/board_screen.dart';
import '../features/play/review/review_screen.dart';
import '../features/theory/library/theory_library_screen.dart';
import '../features/theory/detail/theory_detail_screen.dart';
import '../features/roleplay/roleplay_home_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/history/match_log_screen.dart';
import '../shared/widgets/app_bottom_nav.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/setup',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return AppBottomNav(child: child);
      },
      routes: [
        GoRoute(
          path: '/setup',
          builder: (context, state) => const GameSetupScreen(),
        ),
        GoRoute(
          path: '/theory',
          builder: (context, state) => const TheoryLibraryScreen(),
          routes: [
            GoRoute(
              path: ':id',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return TheoryDetailScreen(theoryId: id);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/roleplay',
          builder: (context, state) => const RoleplayHomeScreen(),
        ),
        GoRoute(
          path: '/history',
          builder: (context, state) => const MatchLogScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/board',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final config = state.extra as Map<String, dynamic>?;
        return BoardScreen(config: config);
      },
    ),
    GoRoute(
      path: '/review/:gameId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final gameId = int.parse(state.pathParameters['gameId']!);
        return ReviewScreen(gameId: gameId);
      },
    ),
  ],
);
