---
name: fix-rating-elo
description: Fix the broken _pow10 implementation in RatingService and write comprehensive Elo unit tests. Use when the user asks to fix ratings, Elo calculation, or rating accuracy.
---

# Skill: Fix RatingService Elo Calculation

## Background

`lib/core/engine/rating_service.dart` contains a broken `_pow10` helper:

```dart
// BROKEN — rounds x to an integer before computing 10^x
static double _pow10(double x) => double.parse(
      (1.0 * (10 * x / 10).ceil()).toStringAsFixed(5),
    ).isNaN
    ? 1.0
    : _exp10(x);
```

The `(10 * x / 10).ceil()` rounds `x` to the next whole number **before** the exponential is computed, making the expected-score formula incorrect (e.g., a 50/50 matchup can yield ~70% expected instead of 50%).

## Fix

Replace `_pow10` with `dart:math`'s `pow`:

```dart
import 'dart:math' as math;

static double _pow10(double x) => math.pow(10, x).toDouble();
```

Remove `_exp10` and `_exp` entirely — they are no longer needed.

## Steps

1. Open `lib/core/engine/rating_service.dart`.
2. Add `import 'dart:math' as math;` at the top.
3. Replace the entire `_pow10`, `_exp10`, and `_exp` methods with the single-line fix above.
4. Run `flutter analyze` — should be clean.
5. Run `flutter test test/core/engine/rating_service_test.dart` — add missing cases first (see below).

## Test Cases to Add to `test/core/engine/rating_service_test.dart`

```dart
test('equal rating match: win gives +16', () {
  final result = RatingService.calculate(
    playerRating: 800, opponentRating: 800, score: 1.0,
  );
  expect(result, 816); // K=32, expected=0.5, delta=+16
});

test('equal rating match: loss gives -16', () {
  final result = RatingService.calculate(
    playerRating: 800, opponentRating: 800, score: 0.0,
  );
  expect(result, 784);
});

test('equal rating match: draw gives 0', () {
  final result = RatingService.calculate(
    playerRating: 800, opponentRating: 800, score: 0.5,
  );
  expect(result, 800);
});

test('rating clamp at minimum 100', () {
  final result = RatingService.calculate(
    playerRating: 100, opponentRating: 2200, score: 0.0,
  );
  expect(result, 100); // already at floor
});

test('K-factor switches at 2100', () {
  // At 2100+, K=24, not 32
  final result = RatingService.calculate(
    playerRating: 2100, opponentRating: 2100, score: 1.0,
  );
  expect(result, 2112); // K=24, delta=+12
});
```

## Verification

```bash
flutter test test/core/engine/rating_service_test.dart
flutter analyze
```
