import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/theory_entry.dart';
import '../../../core/database/app_database.dart';
import '../../../core/supabase/repositories/theory_repository.dart';
import '../../../core/supabase/supabase_client.dart';

part 'theory_provider.g.dart';

class TheoryState {
  final List<TheoryEntry> entries;
  final Map<String, LocalTheoryUserData> userDataMap;
  final String? activePhase;
  final String searchQuery;

  bool isBookmarked(String id) => userDataMap[id]?.isBookmarked ?? false;
  bool isCompleted(String id) => userDataMap[id]?.isCompleted ?? false;

  List<TheoryEntry> get filtered {
    return entries.where((e) {
      final matchesPhase = activePhase == null || e.phase == activePhase;
      final q = searchQuery.toLowerCase();
      final matchesSearch = q.isEmpty ||
          e.title.toLowerCase().contains(q) ||
          e.summary.toLowerCase().contains(q) ||
          e.keyIdeas.any((k) => k.toLowerCase().contains(q)) ||
          e.tags.any((t) => t.toLowerCase().contains(q));
      return matchesPhase && matchesSearch;
    }).toList();
  }

  const TheoryState({
    required this.entries,
    required this.userDataMap,
    this.activePhase,
    this.searchQuery = '',
  });

  TheoryState copyWith({
    List<TheoryEntry>? entries,
    Map<String, LocalTheoryUserData>? userDataMap,
    String? activePhase,
    String? searchQuery,
  }) {
    return TheoryState(
      entries: entries ?? this.entries,
      userDataMap: userDataMap ?? this.userDataMap,
      activePhase: activePhase ?? this.activePhase,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

@riverpod
class TheoryNotifier extends _$TheoryNotifier {
  @override
  Future<TheoryState> build() async {
    final repo = TheoryRepository(
      ref.read(theoryDaoProvider),
      ref.read(cacheServiceProvider),
    );

    // Always returns local cache if available, fetches remotely only on
    // first launch or after TTL expires. Never blocks on network.
    final entries = await repo.get();

    // Sync user-specific data (bookmarks/progress) in background
    if (supabase.auth.currentUser != null) {
      repo.syncUserData(); // fire and forget
    }

    final userDataMap = await ref.read(theoryDaoProvider).getAllUserData();

    return TheoryState(
      entries: entries,
      userDataMap: userDataMap,
    );
  }

  Future<void> refresh() async {
    // Force a remote fetch regardless of TTL
    state = const AsyncValue.loading();
    final repo = TheoryRepository(
      ref.read(theoryDaoProvider),
      ref.read(cacheServiceProvider),
    );
    try {
      final entries = await repo.get(forceRefresh: true);
      final userDataMap = await ref.read(theoryDaoProvider).getAllUserData();
      state = AsyncValue.data(TheoryState(entries: entries, userDataMap: userDataMap));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleBookmark(String theoryId) async {
    final dao = ref.read(theoryDaoProvider);
    final existing = await dao.getUserData(theoryId);
    
    // Optimistic local update — UI updates instantly
    await dao.setBookmark(theoryId, !(existing?.isBookmarked ?? false));

    // Background Supabase push
    TheoryRepository(dao, ref.read(cacheServiceProvider))
        .toggleBookmark(theoryId); // fire and forget

    // Rebuild state from updated local DB
    final userDataMap = await dao.getAllUserData();
    state = state.whenData((s) => s.copyWith(userDataMap: userDataMap));
  }

  Future<void> markCompleted(String theoryId) async {
    final dao = ref.read(theoryDaoProvider);
    await dao.setCompleted(theoryId);
    TheoryRepository(dao, ref.read(cacheServiceProvider))
        .markCompleted(theoryId); // fire and forget

    final userDataMap = await dao.getAllUserData();
    state = state.whenData((s) => s.copyWith(userDataMap: userDataMap));
  }

  void setPhaseFilter(String? phase) {
    state = state.whenData((s) => s.copyWith(activePhase: phase));
  }

  void setSearchQuery(String query) {
    state = state.whenData((s) => s.copyWith(searchQuery: query));
  }
}

// --- Compatibility Providers for existing UI ---

final theoryFilterCategoryProvider = StateProvider<String>((ref) => 'all');
final theorySearchQueryProvider = StateProvider<String>((ref) => '');

final filteredTheoryEntriesProvider = Provider<AsyncValue<List<TheoryEntry>>>((ref) {
  final stateAsync = ref.watch(theoryNotifierProvider);
  final category = ref.watch(theoryFilterCategoryProvider);
  final query = ref.watch(theorySearchQueryProvider).toLowerCase();

  return stateAsync.whenData((state) {
    return state.entries.where((entry) {
      final matchesCategory = category == 'all' || entry.phase == category;
      final matchesQuery = entry.title.toLowerCase().contains(query) ||
          entry.summary.toLowerCase().contains(query) ||
          entry.keyIdeas.any((idea) => idea.toLowerCase().contains(query));
      return matchesCategory && matchesQuery;
    }).toList();
  });
});

final theoryEntryByIdProvider = Provider.family<AsyncValue<TheoryEntry?>, String>((ref, id) {
  final stateAsync = ref.watch(theoryNotifierProvider);
  return stateAsync.whenData((state) {
    try {
      return state.entries.firstWhere((entry) => entry.id == id);
    } catch (_) {
      return null;
    }
  });
});
