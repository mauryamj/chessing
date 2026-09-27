import 'package:flutter_test/flutter_test.dart';
import 'package:chessing/core/engine/rating_service.dart';

void main() {
  group('RatingService.calculate', () {
    test('normal win with equal ratings in <2100 bracket (K=32)', () {
      final newRating = RatingService.calculate(
        playerRating: 1500,
        opponentRating: 1500,
        score: 1.0,
      );
      // Expected = 0.5, Delta = round(32 * (1.0 - 0.5)) = +16
      expect(newRating, 1516);
    });

    test('normal loss with equal ratings in <2100 bracket (K=32)', () {
      final newRating = RatingService.calculate(
        playerRating: 1500,
        opponentRating: 1500,
        score: 0.0,
      );
      // Expected = 0.5, Delta = round(32 * (0.0 - 0.5)) = -16
      expect(newRating, 1484);
    });

    test('normal draw with equal ratings', () {
      final newRating = RatingService.calculate(
        playerRating: 1500,
        opponentRating: 1500,
        score: 0.5,
      );
      // Expected = 0.5, Delta = round(32 * (0.5 - 0.5)) = 0
      expect(newRating, 1500);
    });

    test('upset win against higher rated opponent yields large gain', () {
      final newRating = RatingService.calculate(
        playerRating: 1200,
        opponentRating: 1600,
        score: 1.0,
      );
      expect(newRating, greaterThan(1200 + 16));
    });

    test('expected win against lower rated opponent yields small gain', () {
      final newRating = RatingService.calculate(
        playerRating: 1600,
        opponentRating: 1200,
        score: 1.0,
      );
      expect(newRating, greaterThan(1600));
      expect(newRating, lessThan(1600 + 16));
    });

    test('upset loss against lower rated opponent yields large loss', () {
      final newRating = RatingService.calculate(
        playerRating: 1800,
        opponentRating: 1200,
        score: 0.0,
      );
      expect(newRating, lessThan(1800 - 16));
    });

    test('intermediate bracket (2100-2399) win uses K=24', () {
      final newRating = RatingService.calculate(
        playerRating: 2200,
        opponentRating: 2200,
        score: 1.0,
      );
      // Expected = 0.5, Delta = round(24 * 0.5) = +12
      expect(newRating, 2212);
    });

    test('intermediate bracket (2100-2399) loss uses K=24', () {
      final newRating = RatingService.calculate(
        playerRating: 2200,
        opponentRating: 2200,
        score: 0.0,
      );
      // Expected = 0.5, Delta = round(24 * -0.5) = -12
      expect(newRating, 2188);
    });

    test('high rating bracket (>=2400) win uses K=16', () {
      final newRating = RatingService.calculate(
        playerRating: 2500,
        opponentRating: 2500,
        score: 1.0,
      );
      // Expected = 0.5, Delta = round(16 * 0.5) = +8
      expect(newRating, 2508);
    });

    test('high rating bracket (>=2400) loss uses K=16', () {
      final newRating = RatingService.calculate(
        playerRating: 2500,
        opponentRating: 2500,
        score: 0.0,
      );
      // Expected = 0.5, Delta = round(16 * -0.5) = -8
      expect(newRating, 2492);
    });

    test('lower rating clamp boundary enforces minimum 100', () {
      final newRating = RatingService.calculate(
        playerRating: 100,
        opponentRating: 2000,
        score: 0.0,
      );
      expect(newRating, 100);
    });

    test('loss near floor does not drop below 100', () {
      final newRating = RatingService.calculate(
        playerRating: 105,
        opponentRating: 105,
        score: 0.0,
      );
      // Expected delta is -16 (105 - 16 = 89), clamped to 100
      expect(newRating, 100);
    });

    test('upper rating clamp boundary enforces maximum 3200', () {
      final newRating = RatingService.calculate(
        playerRating: 3200,
        opponentRating: 2000,
        score: 1.0,
      );
      expect(newRating, 3200);
    });

    test('win near ceiling does not exceed 3200', () {
      final newRating = RatingService.calculate(
        playerRating: 3195,
        opponentRating: 3400,
        score: 1.0,
      );
      expect(newRating, 3200);
    });
  });

  group('RatingService.botElo', () {
    test('maps bot levels 1 to 10 correctly and clamps out-of-range levels', () {
      expect(RatingService.botElo(1), 600);
      expect(RatingService.botElo(2), 800);
      expect(RatingService.botElo(5), 1400);
      expect(RatingService.botElo(8), 1900);
      expect(RatingService.botElo(10), 2200);

      // Clamp tests
      expect(RatingService.botElo(0), 600);
      expect(RatingService.botElo(15), 2200);
    });
  });
}
