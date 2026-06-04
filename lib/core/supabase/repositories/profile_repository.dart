import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase_client.dart';

class ProfileRepository {
  Future<Map<String, dynamic>?> fetchProfile(String userId) async {
    try {
      final res = await supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      return res;
    } catch (_) {
      return null;
    }
  }

  Future<void> updateProfile({
    required String userId,
    String? username,
    String? avatarUrl,
  }) async {
    await supabase.from('profiles').update({
      if (username != null) 'username': username,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
    }).eq('id', userId);
  }

  Future<void> updateStats({
    required String userId,
    required int currentRating,
    required int peakRating,
    required int gamesPlayed,
    required int wins,
    required int draws,
    required int losses,
  }) async {
    await supabase.from('profiles').update({
      'current_rating': currentRating,
      'peak_rating': peakRating,
      'games_played': gamesPlayed,
      'wins': wins,
      'draws': draws,
      'losses': losses,
    }).eq('id', userId);
  }

  Future<String> uploadAvatar(String userId, File imageFile) async {
    final path = '$userId/avatar.jpg';
    await supabase.storage.from('avatars').upload(
      path,
      imageFile,
      fileOptions: const FileOptions(upsert: true),
    );
    return supabase.storage.from('avatars').getPublicUrl(path);
  }
}
