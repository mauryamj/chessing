import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> initSupabase() async {
  final url = dotenv.env['SUPABASE_URL'] ?? 'https://placeholder.supabase.co';
  final anonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? 'placeholder-anon-key';
  
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
