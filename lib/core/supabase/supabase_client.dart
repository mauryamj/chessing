import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> initSupabase() async {
  final url = dotenv.env['SUPABASE_URL'] ?? 'https://placeholder.supabase.co';
  final anonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? 'placeholder-anon-key';
  
  await Supabase.initialize(
    url: url,
    anonKey: anonKey,
  );
}

SupabaseClient get supabase => Supabase.instance.client;
