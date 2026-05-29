/// Simple Elo rating service.
///
/// K-factor:  32 for players rated < 2100
///            24 for 2100–2399
///            16 for ≥ 2400
///
/// Bot level → approximate Elo mapping:
///   Level 1 ≈ 600   Level 5 ≈ 1400   Level 8 ≈ 1900
///   Level 2 ≈ 800   Level 6 ≈ 1600   Level 9 ≈ 2100
///   Level 3 ≈ 1000  Level 7 ≈ 1750   Level 10 ≈ 2200
///   Level 4 ≈ 1200
class RatingService {
  static const _botEloMap = {
    1: 600,
    2: 800,
    3: 1000,
    4: 1200,
    5: 1400,
    6: 1600,
    7: 1750,
    8: 1900,
    9: 2100,
    10: 2200,
  };

  /// Returns the approximate Elo of a bot at the given skill level.
  static int botElo(int level) => _botEloMap[level.clamp(1, 10)] ?? 1400;

  /// Calculates the new Elo rating for the player.
  ///
  /// [playerRating] — current player rating.
  /// [opponentRating] — opponent (bot) rating.
  /// [score] — 1.0 for win, 0.5 for draw, 0.0 for loss.
  static int calculate({
    required int playerRating,
    required int opponentRating,
    required double score,
  }) {
    final k = _kFactor(playerRating);
    final expected =
        1.0 / (1.0 + _pow10((opponentRating - playerRating) / 400.0));
    final newRating = playerRating + (k * (score - expected)).round();
    return newRating.clamp(100, 3200);
  }

  static int _kFactor(int rating) {
    if (rating >= 2400) return 16;
    if (rating >= 2100) return 24;
    return 32;
  }

  static double _pow10(double x) => double.parse(
        (1.0 * (10 * x / 10).ceil()).toStringAsFixed(5),
      ).isNaN
      ? 1.0
      : _exp10(x);

  static double _exp10(double x) {
    // 10^x = e^(x * ln10)
    return _exp(x * 2.302585092994046);
  }

  // Simple Taylor-series exp approximation (sufficient for Elo range)
  static double _exp(double x) {
    if (x > 20) return 485165195.4097903;
    if (x < -20) return 2.061153622438558e-9;
    double result = 1.0;
    double term = 1.0;
    for (int i = 1; i <= 20; i++) {
      term *= x / i;
      result += term;
    }
    return result;
  }
}
