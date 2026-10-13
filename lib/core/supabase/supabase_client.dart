import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String getSupabaseUrl() {
  const compileTime = String.fromEnvironment('SUPABASE_URL');
  if (compileTime.isNotEmpty) return compileTime;
  if (dotenv.isInitialized) {
    final fromDotenv = dotenv.maybeGet('SUPABASE_URL');
    if (fromDotenv != null && fromDotenv.isNotEmpty) return fromDotenv;
  }
  return 'https://placeholder.supabase.co';
}

String getSupabaseAnonKey() {
  const compileTime = String.fromEnvironment('SUPABASE_ANON_KEY');
  if (compileTime.isNotEmpty) return compileTime;
  if (dotenv.isInitialized) {
    final fromDotenv = dotenv.maybeGet('SUPABASE_ANON_KEY');
    if (fromDotenv != null && fromDotenv.isNotEmpty) return fromDotenv;
  }
  return 'placeholder-anon-key';
}

Future<void> initSupabase() async {
  final url = getSupabaseUrl();
  final anonKey = getSupabaseAnonKey();
  
  await Supabase.initialize(
    url: url,
    // ignore: deprecated_member_use
    anonKey: anonKey,
  );
}

bool get isSupabaseInitialized {
  try {
    return Supabase.instance.isInitialized;
  } catch (_) {
    return false;
  }
}

SupabaseClient? get safeSupabase {
  try {
    return Supabase.instance.client;
  } catch (_) {
    return null;
  }
}

SupabaseClient get supabase => Supabase.instance.client;
