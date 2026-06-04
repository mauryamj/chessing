import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../supabase/repositories/auth_repository.dart';
import '../supabase/sync/sync_service.dart';
import '../firebase/fcm_service.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthStateModel> {
  final Ref _ref;
  StreamSubscription<AuthState>? _authSubscription;
  final AuthRepository _authRepo = AuthRepository();

  AuthNotifier(this._ref) : super(const AuthLoading()) {
    _initialize();
  }

  void _initialize() {
    _authSubscription = _authRepo.authStateChanges.listen((data) {
      if (data.session != null) {
        state = AuthAuthenticated(data.session!.user);
      } else {
        // Only set to unauthenticated if we aren't in guest mode
        if (state is! AuthGuest) {
          state = const AuthUnauthenticated();
        }
      }
    });

    final user = _authRepo.currentUser;
    if (user != null) {
      state = AuthAuthenticated(user);
    } else {
      state = const AuthUnauthenticated();
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AuthLoading();
    try {
      final webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'] ?? const String.fromEnvironment('GOOGLE_WEB_CLIENT_ID');
      final googleSignIn = GoogleSignIn(
        clientId: webClientId,
        serverClientId: webClientId,
        scopes: ['email', 'profile'],
      );

      // Always sign out first to force account picker
      try {
        await googleSignIn.signOut();
      } catch (_) {}

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        state = const AuthUnauthenticated();
        return;
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken == null || accessToken == null) {
        throw Exception(
          'Google Sign-In returned null tokens. '
          'idToken: ${idToken == null ? "NULL" : "present"}, '
          'accessToken: ${accessToken == null ? "NULL" : "present"}. '
          'Ensure serverClientId is the Web client ID, not Android.',
        );
      }

      await _authRepo.signInWithIdToken(
        idToken: idToken,
        accessToken: accessToken,
      );

      // Initialize FCM and sync
      await _ref.read(syncServiceProvider).pullFromCloud();
      
      try {
        await FcmService().initialize();
      } catch (_) {}

      // State is auto-updated by the auth change listener
    } on AuthException catch (e) {
      state = AuthError('Supabase auth error: ${e.message}');
      debugPrint('Supabase AuthException: ${e.message} | status: ${e.statusCode}');
    } catch (e, stack) {
      state = AuthError(e.toString());
      debugPrint('Sign-in error: $e\n$stack');
    }
  }

  Future<void> signInAsGuest() async {
    state = const AuthGuest();
  }

  Future<void> signOut() async {
    state = const AuthLoading();
    try {
      await FcmService().deleteToken();
    } catch (_) {}
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
    try {
      await _authRepo.signOut();
    } catch (_) {}
    state = const AuthUnauthenticated();
  }

  Future<void> deleteAccount() async {
    state = const AuthLoading();
    try {
      await FcmService().deleteToken();
    } catch (_) {}
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
    try {
      await _authRepo.deleteAccount();
    } catch (_) {}
    state = const AuthUnauthenticated();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthStateModel>((ref) {
  return AuthNotifier(ref);
});
