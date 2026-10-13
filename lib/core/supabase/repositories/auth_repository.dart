import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase_client.dart';

class AuthRepository {
  Future<void> signInWithIdToken({
    required String idToken,
    required String accessToken,
  }) async {
    if (!isSupabaseInitialized) return;
    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  Future<void> signOut() async {
    if (!isSupabaseInitialized) return;
    await supabase.auth.signOut();
  }

  Future<void> deleteAccount() async {
    if (!isSupabaseInitialized) return;
    // Invoke the Edge Function that removes the auth.users row server-side.
    // Throws if the function fails — callers must handle this explicitly.
    await supabase.functions.invoke('delete-account');
    await signOut();
  }

  User? get currentUser =>
      isSupabaseInitialized ? supabase.auth.currentUser : null;

  Stream<AuthState> get authStateChanges => isSupabaseInitialized
      ? supabase.auth.onAuthStateChange
      : const Stream.empty();
}
