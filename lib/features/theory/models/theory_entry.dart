class Variation {
  final String name;
  final List<String> moves;

  Variation({
    required this.name,
    required this.moves,
  });

  factory Variation.fromJson(Map<String, dynamic> json) {
    return Variation(
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
  final String summary;
  final List<String> moves;
  final List<String> keyIdeas;
  final List<Variation> variations;

  TheoryEntry({
    required this.id,
    required this.phase,
    required this.title,
    required this.summary,
    required this.moves,
    required this.keyIdeas,
    required this.variations,
  });

  factory TheoryEntry.fromJson(Map<String, dynamic> json) {
    return TheoryEntry(
      id: json['id'] as String,
      phase: json['phase'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      moves: List<String>.from(json['moves'] as List),
      keyIdeas: List<String>.from(json['keyIdeas'] as List),
      variations: (json['variations'] as List)
          .map((v) => Variation.fromJson(v as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phase': phase,
      'title': title,
      'summary': summary,
      'moves': moves,
      'keyIdeas': keyIdeas,
      'variations': variations.map((v) => v.toJson()).toList(),
    };
  }
}
