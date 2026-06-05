class TheoryVariation {
  final String name;
  final List<String> moves;

  TheoryVariation({
    required this.name,
    required this.moves,
  });

  factory TheoryVariation.fromJson(Map<String, dynamic> json) {
    return TheoryVariation(
      name: json['name'] as String,
      moves: List<String>.from(json['moves'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'moves': moves,
    };
  }
}

class TheoryEntry {
  final String id;
  final String phase; // 'opening' | 'middlegame' | 'endgame'
  final String title;
  final String? subtitle;
  final String summary;
  final List<String> moves;
  final List<String> keyIdeas;
  final List<TheoryVariation> variations;
  final String difficulty;
  final List<String> tags;
  final int sortOrder;

  TheoryEntry({
    required this.id,
    required this.phase,
    required this.title,
    this.subtitle,
    required this.summary,
    required this.moves,
    required this.keyIdeas,
    required this.variations,
    required this.difficulty,
    required this.tags,
    required this.sortOrder,
  });

  factory TheoryEntry.fromJson(Map<String, dynamic> json) {
    return TheoryEntry(
      id: json['id'] as String,
      phase: json['phase'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      summary: json['summary'] as String,
      moves: List<String>.from(json['moves'] as List? ?? []),
      keyIdeas: List<String>.from(
          (json['key_ideas'] ?? json['keyIdeas']) as List? ?? []),
      variations: (json['variations'] as List? ?? [])
          .map((v) => TheoryVariation.fromJson(v as Map<String, dynamic>))
          .toList(),
      difficulty: json['difficulty'] as String? ?? 'Intermediate',
      tags: List<String>.from(json['tags'] as List? ?? []),
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phase': phase,
      'title': title,
      'subtitle': subtitle,
      'summary': summary,
      'moves': moves,
      'key_ideas': keyIdeas,
      'variations': variations.map((v) => v.toJson()).toList(),
      'difficulty': difficulty,
      'tags': tags,
      'sort_order': sortOrder,
    };
  }
}
