import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase_client.dart';
import '../../cache/cache_service.dart';

class UserProfile {
  final String id;
  final String username;
  final String? avatarUrl;
  final int currentRating;
  final int peakRating;
  final int gamesPlayed;
  final int wins;
  final int draws;
  final int losses;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.username,
    this.avatarUrl,
    required this.currentRating,
    required this.peakRating,
    required this.gamesPlayed,
    required this.wins,
    required this.draws,
    required this.losses,
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      username: json['username'] as String? ?? 'Player',
      avatarUrl: json['avatar_url'] as String?,
      currentRating: json['current_rating'] as int? ?? 800,
      peakRating: json['peak_rating'] as int? ?? 800,
      gamesPlayed: json['games_played'] as int? ?? 0,
      wins: json['wins'] as int? ?? 0,
      draws: json['draws'] as int? ?? 0,
      losses: json['losses'] as int? ?? 0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'avatar_url': avatarUrl,
      'current_rating': currentRating,
      'peak_rating': peakRating,
      'games_played': gamesPlayed,
      'wins': wins,
      'draws': draws,
      'losses': losses,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class ProfileRepository {
  final CacheService _cache;

  ProfileRepository(this._cache);

  // Profile is stored in memory only after first fetch — no dedicated local table.
  // It is small enough that in-memory is fine and avoids a stale display.
  static UserProfile? _inMemoryCache;

  Future<UserProfile?> getProfile({bool forceRefresh = false}) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return null;

    // Return in-memory cache if fresh
    if (!forceRefresh &&
        _inMemoryCache != null &&
        !await _cache.isStale('profile')) {
      return _inMemoryCache;
    }

    try {
      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      _inMemoryCache = UserProfile.fromJson(data);
      await _cache.markFetched('profile', 1);
      return _inMemoryCache;
    } catch (e) {
      // Network error — return stale in-memory if available
      debugPrint('Profile fetch failed: $e — using stale cache');
      return _inMemoryCache;
    }
  }

  static void invalidateMemoryCache() {
    _inMemoryCache = null;
  }

  Future<void> updateProfile({String? username, String? avatarUrl}) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;
    await supabase.from('profiles').update({
      if (username != null) 'username': username,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
    }).eq('id', userId);
    await _cache.invalidate('profile');
    invalidateMemoryCache();
  }

  Future<void> updateStats({
    required int currentRating,
    required int peakRating,
    required int gamesPlayed,
    required int wins,
    required int draws,
    required int losses,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;
    await supabase.from('profiles').update({
      'current_rating': currentRating,
      'peak_rating': peakRating,
      'games_played': gamesPlayed,
      'wins': wins,
      'draws': draws,
      'losses': losses,
    }).eq('id', userId);
    await _cache.invalidate('profile');
    invalidateMemoryCache();
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
