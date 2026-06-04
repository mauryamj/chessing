import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../features/play/setup/game_setup_screen.dart';
import '../features/play/board/board_screen.dart';
import '../features/play/review/review_screen.dart';
import '../features/theory/library/theory_library_screen.dart';
import '../features/theory/detail/theory_detail_screen.dart';
import '../features/roleplay/roleplay_home_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/history/match_log_screen.dart';
import '../features/history/performance_screen.dart';
import '../shared/widgets/app_bottom_nav.dart';
import '../features/roleplay/modes/why_this_move_screen.dart';
import '../features/roleplay/modes/coach_persona_screen.dart';
import '../features/roleplay/modes/historical_match_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/splash_screen.dart';
import '../core/auth/auth_provider.dart';
import '../core/auth/auth_state.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

class _GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  _GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((dynamic _) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: _GoRouterRefreshStream(ref.read(authNotifierProvider.notifier).stream),
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      final isLoggedIn = authState is AuthAuthenticated || authState is AuthGuest;
      final isLoggingIn = state.matchedLocation == '/login';
      final isSplashing = state.matchedLocation == '/splash';

      if (authState is AuthLoading) {
        if (isLoggingIn || isSplashing) return null;
        return '/splash';
      }

      if (!isLoggedIn) {
        if (!isLoggingIn) return '/login';
        return null;
      }

      if (isLoggedIn && (isLoggingIn || isSplashing)) {
        return '/setup';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
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
        path: '/settings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/theory/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return TheoryDetailScreen(theoryId: id);
        },
      ),
      GoRoute(
        path: '/roleplay/why-this-move',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const WhyThisMoveScreen(),
      ),
      GoRoute(
        path: '/roleplay/coach-persona',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CoachPersonaScreen(),
      ),
      GoRoute(
        path: '/roleplay/historical',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const HistoricalMatchScreen(),
      ),
      GoRoute(
        path: '/history/performance',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PerformanceScreen(),
      ),
      GoRoute(
        path: '/board',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final config = state.extra as Map<String, dynamic>?;
          return _slideUpPage(
            state: state,
            child: BoardScreen(config: config),
          );
        },
      ),
      GoRoute(
        path: '/review/:gameId',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final gameId = int.parse(state.pathParameters['gameId']!);
          return _slideUpPage(
            state: state,
            child: ReviewScreen(gameId: gameId),
          );
        },
      ),
    ],
  );
});

/// Slide-up page transition used for board & review screens.
CustomTransitionPage<void> _slideUpPage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 280),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(curved),
        child: FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}
