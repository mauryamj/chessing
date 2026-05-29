import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/database/app_database.dart';

class AccuracyChart extends StatefulWidget {
  final List<Game> games;

  const AccuracyChart({super.key, required this.games});

  @override
  State<AccuracyChart> createState() => _AccuracyChartState();
}

class _AccuracyChartState extends State<AccuracyChart> {
  int _touchedIndex = -1;

  Color _barColor(int acc) {
    if (acc >= 85) return const Color(0xFF4CAF50);
    if (acc >= 65) return const Color(0xFFFFC107);
    return const Color(0xFFF44336);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Last 20 games sorted chronologically
    final sorted = [...widget.games]
      ..sort((a, b) => a.playedAt.compareTo(b.playedAt));

    final displayed = sorted
        .where((g) => g.playerAccuracy != null)
        .toList()
        .reversed
        .take(20)
        .toList()
        .reversed
        .toList();

    if (displayed.isEmpty) {
      return Center(
        child: Text(
          'No accuracy data yet. Finish a reviewed game!',
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: cs.onSurface.withValues(alpha: 0.5)),
          textAlign: TextAlign.center,
        ),
      );
    }

    final bars = displayed.asMap().entries.map((e) {
      final index = e.key;
      final g = e.value;
      final acc = g.playerAccuracy!;
      final isTouched = index == _touchedIndex;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: acc.toDouble(),
            color: _barColor(acc).withValues(
              alpha: isTouched ? 1.0 : 0.75,
            ),
            width: isTouched ? 14 : 11,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(6),
            ),
          ),
        ],
        showingTooltipIndicators: isTouched ? [0] : [],
      );
    }).toList();

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          maxY: 100,
          minY: 0,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 25,
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
                reservedSize: 36,
                interval: 25,
                getTitlesWidget: (v, _) => Text(
                  '${v.toInt()}%',
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
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => cs.surfaceContainerHighest,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${rod.toY.round()}%',
                  TextStyle(
                    color: cs.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              },
            ),
            touchCallback: (event, response) {
              setState(() {
                _touchedIndex =
                    response?.spot?.touchedBarGroupIndex ?? -1;
              });
            },
          ),
          barGroups: bars,
        ),
      ),
    );
  }
}
