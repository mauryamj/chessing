import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/theory_entry.dart';

final theoryEntriesProvider = FutureProvider<List<TheoryEntry>>((ref) async {
  final jsonString = await rootBundle.loadString('assets/theory/theory.json');
  final List<dynamic> jsonList = json.decode(jsonString);
  return jsonList.map((json) => TheoryEntry.fromJson(json)).toList();
});

final theoryFilterCategoryProvider = StateProvider<String>((ref) => 'all');
final theorySearchQueryProvider = StateProvider<String>((ref) => '');

final filteredTheoryEntriesProvider = Provider<AsyncValue<List<TheoryEntry>>>((ref) {
  final entriesAsync = ref.watch(theoryEntriesProvider);
  final category = ref.watch(theoryFilterCategoryProvider);
  final query = ref.watch(theorySearchQueryProvider).toLowerCase();

  return entriesAsync.whenData((entries) {
    return entries.where((entry) {
      final matchesCategory = category == 'all' || entry.phase == category;
      final matchesQuery = entry.title.toLowerCase().contains(query) ||
          entry.summary.toLowerCase().contains(query) ||
          entry.keyIdeas.any((idea) => idea.toLowerCase().contains(query));
      return matchesCategory && matchesQuery;
    }).toList();
  });
});

final theoryEntryByIdProvider = Provider.family<AsyncValue<TheoryEntry?>, String>((ref, id) {
  final entriesAsync = ref.watch(theoryEntriesProvider);
  return entriesAsync.whenData((entries) {
    try {
      return entries.firstWhere((entry) => entry.id == id);
    } catch (_) {
      return null;
    }
  });
});
