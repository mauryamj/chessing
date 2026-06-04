import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase_client.dart';

class AuthRepository {
  Future<void> signInWithIdToken({
    required String idToken,
    required String accessToken,
  }) async {
    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  Future<void> deleteAccount() async {
    try {
      // Call a Supabase Edge Function that deletes auth.users row
      await supabase.functions.invoke('delete-account');
    } catch (_) {
      // Fallback: delete client session if Edge Function doesn't exist
      await signOut();
    }
  }

  User? get currentUser => supabase.auth.currentUser;

  Stream<AuthState> get authStateChanges =>
      supabase.auth.onAuthStateChange;
}
