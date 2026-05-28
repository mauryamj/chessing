import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

/// A custom marker theme for legal moves highlighting.
/// Displays a hollow circle for empty squares, and a ring around pieces for capture moves.
final MarkerTheme legalMovesMarkerTheme = MarkerTheme(
  empty: (context, size, colour) => Center(
    child: Container(
      width: size * 0.3,
      height: size * 0.3,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: colour.withValues(alpha: 0.6),
          width: 2.0,
        ),
        color: Colors.transparent,
      ),
    ),
  ),
  piece: (context, size, colour) => Center(
    child: Container(
      width: size * 0.85,
      height: size * 0.85,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: colour.withValues(alpha: 0.6),
          width: 3.5,
        ),
        color: Colors.transparent,
      ),
    ),
  ),
);
