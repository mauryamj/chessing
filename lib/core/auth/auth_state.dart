import 'package:supabase_flutter/supabase_flutter.dart';

sealed class AuthStateModel {
  const AuthStateModel();
}

class AuthUnauthenticated extends AuthStateModel {
  const AuthUnauthenticated();
}

class AuthLoading extends AuthStateModel {
  const AuthLoading();
}

class AuthAuthenticated extends AuthStateModel {
  final User user;
  const AuthAuthenticated(this.user);
}

class AuthGuest extends AuthStateModel {
  const AuthGuest();
}

class AuthError extends AuthStateModel {
  final String message;
  const AuthError(this.message);
}
