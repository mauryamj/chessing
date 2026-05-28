
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../review_provider.dart';

class MoveTimeline extends StatelessWidget {
  final List<ReviewMove> moves;
  final int currentPly;
  final Function(int) onPlySelected;

  const MoveTimeline({
    super.key,
    required this.moves,
    required this.currentPly,
    required this.onPlySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (moves.isEmpty) {
      return const SizedBox(
        height: 60,
        child: Center(child: Text('No moves to display')),
      );
    }

    // Build spots
    // X = 0 is starting position (eval = 0 or initial evaluation)
    // X = i + 1 is move i (ply i)
    final List<FlSpot> spots = [];
    spots.add(const FlSpot(0, 0)); // Start position

    for (int i = 0; i < moves.length; i++) {
      final m = moves[i];
      final double evalPawns = (m.eval ?? 0) / 100.0;
      // Clamp evals to -5.0 to +5.0 for visualization
      final double clampedEval = evalPawns.clamp(-5.0, 5.0);
      spots.add(FlSpot((i + 1).toDouble(), clampedEval));
    }

    // Calculate maximum ply for scaling
    final double maxX = spots.length.toDouble() - 1.0;

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 2.5,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: value == 0
                    ? theme.dividerColor.withValues(alpha: 0.3)
                    : theme.dividerColor.withValues(alpha: 0.1),
                strokeWidth: value == 0 ? 1.5 : 1.0,
                dashArray: value == 0 ? null : [4, 4],
              );
            },
          ),
          titlesData: const FlTitlesData(
            show: false, // Hide all default axis labels
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: maxX,
          minY: -5.0,
          maxY: 5.0,
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (spot) => theme.colorScheme.surface.withValues(alpha: 0.9),
              tooltipBorder: BorderSide(color: theme.colorScheme.primary, width: 1),
              tooltipPadding: const EdgeInsets.all(6),
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((touchedSpot) {
                  final int ply = touchedSpot.x.toInt() - 1;
                  String plyName = ply == -1 ? 'Start' : 'Move ${((ply + 2) ~/ 2)}';
                  if (ply >= 0) {
                    final side = ply % 2 == 0 ? 'W' : 'B';
                    plyName += ' ($side: ${moves[ply].san})';
                  }
                  final double val = touchedSpot.y;
                  final String evalStr = val > 0 ? '+${val.toStringAsFixed(1)}' : val.toStringAsFixed(1);
                  return LineTooltipItem(
                    '$plyName\n$evalStr',
                    theme.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  );
                }).toList();
              },
            ),
            handleBuiltInTouches: true,
            touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
              if (event is FlTapUpEvent && response != null && response.lineBarSpots != null) {
                final spot = response.lineBarSpots!.first;
                final int selectedPly = spot.x.toInt() - 1;
                onPlySelected(selectedPly);
              }
            },
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              preventCurveOverShooting: true,
              color: theme.colorScheme.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  final int spotPly = spot.x.toInt() - 1;
                  final bool isActive = spotPly == currentPly;
                  
                  if (isActive) {
                    return FlDotCirclePainter(
                      radius: 5,
                      color: theme.colorScheme.primary,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    );
                  }
                  
                  // Color dot based on classification if analyzed
                  if (spotPly >= 0 && spotPly < moves.length) {
                    final classification = moves[spotPly].classification;
                    Color dotColor = theme.dividerColor.withValues(alpha: 0.3);
                    if (classification == 'best' || classification == 'good') {
                      dotColor = Colors.green;
                    } else if (classification == 'inaccuracy') {
                      dotColor = Colors.yellow[700]!;
                    } else if (classification == 'mistake') {
                      dotColor = Colors.orange;
                    } else if (classification == 'blunder') {
                      dotColor = Colors.red;
                    }
                    return FlDotCirclePainter(
                      radius: 2.5,
                      color: dotColor,
                      strokeWidth: 0,
                    );
                  }
                  
                  return FlDotCirclePainter(
                    radius: 2,
                    color: theme.dividerColor.withValues(alpha: 0.3),
                    strokeWidth: 0,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.2),
                    theme.colorScheme.primary.withValues(alpha: 0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
