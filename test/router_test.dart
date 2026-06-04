import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chessing/app/router.dart';
import 'package:chessing/core/auth/auth_provider.dart';
import 'package:chessing/core/auth/auth_state.dart';
import 'package:chessing/features/auth/splash_screen.dart';
import 'package:chessing/features/auth/login_screen.dart';
import 'package:chessing/features/play/setup/game_setup_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FakeAuthNotifier extends StateNotifier<AuthStateModel> implements AuthNotifier {
  FakeAuthNotifier(AuthStateModel state) : super(state);

  void setState(AuthStateModel newState) {
    state = newState;
  }

  @override
  Future<void> signInWithGoogle() async {}

  @override
  Future<void> signInAsGuest() async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<void> deleteAccount() async {}
}

class RouterTestApp extends ConsumerWidget {
  const RouterTestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}

void main() {
  group('Router Redirect Tests', () {
    testWidgets('should show SplashScreen when auth is loading', (tester) async {
      final notifier = FakeAuthNotifier(const AuthLoading());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authNotifierProvider.overrideWith((ref) => notifier),
          ],
          child: const RouterTestApp(),
        ),
      );

      await tester.pump();

      // Verify splash screen shows
      expect(find.byType(SplashScreen), findsOneWidget);
    });

    testWidgets('should redirect from SplashScreen to LoginScreen when unauthenticated', (tester) async {
      final notifier = FakeAuthNotifier(const AuthLoading());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authNotifierProvider.overrideWith((ref) => notifier),
          ],
          child: const RouterTestApp(),
        ),
      );

      await tester.pump();
      expect(find.byType(SplashScreen), findsOneWidget);

      // Transition state to unauthenticated
      notifier.setState(const AuthUnauthenticated());
      
      // Let the router process the redirect and pump UI frames
      await tester.pump(); // Start routing transition
      await tester.pump(const Duration(milliseconds: 100)); // Complete transition
      await tester.pumpAndSettle(); // Settle any pending animations

      // Verify it navigated to LoginScreen
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('should redirect to GameSetupScreen when logged in authenticated', (tester) async {
      final mockUser = User(
        id: 'test-user-id',
        appMetadata: const {},
        userMetadata: const {},
        aud: 'authenticated',
        createdAt: '2026-06-02T12:00:00Z',
      );
      final notifier = FakeAuthNotifier(AuthAuthenticated(mockUser));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authNotifierProvider.overrideWith((ref) => notifier),
          ],
          child: const RouterTestApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify it navigated to GameSetupScreen
      expect(find.byType(GameSetupScreen), findsOneWidget);
    });

    testWidgets('should redirect to GameSetupScreen when logged in as guest', (tester) async {
      final notifier = FakeAuthNotifier(const AuthGuest());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authNotifierProvider.overrideWith((ref) => notifier),
          ],
          child: const RouterTestApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify it navigated to GameSetupScreen
      expect(find.byType(GameSetupScreen), findsOneWidget);
    });
  });
}
