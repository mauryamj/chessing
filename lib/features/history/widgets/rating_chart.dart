import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/game_summary.dart';

class RatingChart extends StatefulWidget {
  final List<GameSummary> games;
  final int startRating;

  const RatingChart({
    super.key,
    required this.games,
    this.startRating = 800,
  });

  @override
  State<RatingChart> createState() => _RatingChartState();
}

class _RatingChartState extends State<RatingChart> {
  int? _touchedIndex;

  List<FlSpot> _buildSpots(List<_RatingPoint> points) {
    return List.generate(
      points.length,
      (i) => FlSpot(i.toDouble(), points[i].rating.toDouble()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Sort games chronologically and reconstruct rating history
    final sorted = [...widget.games]
      ..sort((a, b) => a.playedAt.compareTo(b.playedAt));

    // We only have the final rating, so we simulate a rough history:
    // Starting from startRating, pretend +/-32 Elo per game based on result.
    // This is an approximation for display; the real changes are in profile.
    final points = <_RatingPoint>[];
    int r = widget.startRating;
    for (final g in sorted) {
      final playerWon = g.result == '1-0' && g.playerColorIndex == 0 ||
          g.result == '0-1' && g.playerColorIndex == 1;
      final isDraw = g.result == '1/2-1/2';
      final delta = playerWon ? 20 : (isDraw ? 0 : -18);
      r = (r + delta).clamp(100, 3200);
      points.add(_RatingPoint(rating: r, date: g.playedAt));
    }

    if (points.isEmpty) {
      return Center(
        child: Text(
          'Play some games to see your rating chart!',
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: cs.onSurface.withValues(alpha: 0.5)),
          textAlign: TextAlign.center,
        ),
      );
    }

    final spots = _buildSpots(points);
    final minY =
        (spots.map((s) => s.y).reduce((a, b) => a < b ? a : b) - 50)
            .clamp(100.0, 3000.0);
    final maxY =
        (spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) + 50)
            .clamp(200.0, 3200.0);

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 100,
            getDrawingHorizontalLine: (v) => FlLine(
              color: cs.outline.withValues(alpha: 0.15),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 100,
                getTitlesWidget: (v, _) => Text(
                  '${v.toInt()}',
                  style: TextStyle(
                    fontSize: 10,
                    color: cs.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
            bottomTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => cs.surfaceContainerHighest,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((s) {
                  final pt = points[s.spotIndex];
                  final dateStr =
                      DateFormat('MMM d').format(pt.date.toLocal());
                  return LineTooltipItem(
                    '${pt.rating}\n$dateStr',
                    TextStyle(
                      color: cs.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                }).toList();
              },
            ),
            touchCallback: (event, response) {
              setState(() {
                _touchedIndex =
                    response?.lineBarSpots?.first.spotIndex;
              });
            },
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.35,
              color: cs.primary,
              barWidth: 2.5,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, pct, bar, index) =>
                    FlDotCirclePainter(
                  radius: index == _touchedIndex ? 5 : 3,
                  color: cs.primary,
                  strokeWidth: 1.5,
                  strokeColor: cs.surface,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    cs.primary.withValues(alpha: 0.25),
                    cs.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingPoint {
  final int rating;
  final DateTime date;
  const _RatingPoint({required this.rating, required this.date});
}
