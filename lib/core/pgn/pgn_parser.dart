class PgnParser {
  /// Parses a PGN string into a list of clean move strings (e.g. ['e4', 'c5', 'Nf3', ...]).
  static List<String> parseMoves(String pgn) {
    // 1. Remove PGN headers (lines wrapped in brackets)
    final headersRemoved = pgn.replaceAll(RegExp(r'\[.*?\]'), '');
    
    // 2. Remove comments (text inside curly braces)
    final commentsRemoved = headersRemoved.replaceAll(RegExp(r'\{.*?\}'), '');
    
    // 3. Remove variations (text inside parentheses)
    final variationsRemoved = commentsRemoved.replaceAll(RegExp(r'\(.*?\u0029'), '');
    
    // 4. Tokenize by whitespace
    final tokens = variationsRemoved.split(RegExp(r'\s+'));
    final List<String> moves = [];
    
    for (final token in tokens) {
      if (token.isEmpty) continue;
      // Skip move numbers (e.g. "1.", "1...", "20.")
      if (RegExp(r'^\d+\.+$').hasMatch(token)) continue;
      // Skip result signs
      if (token == '1-0' || token == '0-1' || token == '1/2-1/2' || token == '*') continue;
      
      // Remove any numeric tags from move (like "1.e4" without space)
      var cleanToken = token;
      if (token.contains('.')) {
        final parts = token.split('.');
        cleanToken = parts.last;
      }
      if (cleanToken.isNotEmpty) {
        moves.add(cleanToken);
      }
    }
    return moves;
  }
}
