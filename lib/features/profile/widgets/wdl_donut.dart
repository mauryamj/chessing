import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/database/app_database.dart';

class WdlDonut extends StatefulWidget {
  final ProfileData profile;

  const WdlDonut({super.key, required this.profile});

  @override
  State<WdlDonut> createState() => _WdlDonutState();
}

class _WdlDonutState extends State<WdlDonut> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final w = widget.profile.wins;
    final d = widget.profile.draws;
    final l = widget.profile.losses;
    final total = w + d + l;

    if (total == 0) {
      return Container(
        height: 180,
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            'No games yet',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: cs.onSurface.withValues(alpha: 0.5)),
          ),
        ),
      );
    }

    final sections = [
      _section(0, w, total, const Color(0xFF4CAF50), 'W', theme),
      _section(1, d, total, const Color(0xFF9E9E9E), 'D', theme),
      _section(2, l, total, const Color(0xFFF44336), 'L', theme),
    ];

    return SizedBox(
      height: 180,
      child: Row(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 52,
                sectionsSpace: 3,
                pieTouchData: PieTouchData(
                  touchCallback: (event, response) {
                    setState(() {
                      _touchedIndex =
                          response?.touchedSection?.touchedSectionIndex ?? -1;
                    });
                  },
                ),
              ),
            ),
          ),
          // Centre label (overlaid via Stack) + legend
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _legendRow('Win', w, total, const Color(0xFF4CAF50), theme),
              const SizedBox(height: 8),
              _legendRow('Draw', d, total, const Color(0xFF9E9E9E), theme),
              const SizedBox(height: 8),
              _legendRow('Loss', l, total, const Color(0xFFF44336), theme),
              const SizedBox(height: 16),
              Text(
                '$total',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'total',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  PieChartSectionData _section(int index, int value, int total, Color color,
      String label, ThemeData theme) {
    final isTouched = index == _touchedIndex;
    final pct = total > 0 ? (value / total * 100).round() : 0;
    return PieChartSectionData(
      value: value.toDouble(),
      color: color,
      radius: isTouched ? 52 : 44,
      title: isTouched ? '$pct%' : '',
      titleStyle: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
    );
  }

  Widget _legendRow(
      String label, int value, int total, Color color, ThemeData theme) {
    final pct = total > 0 ? (value / total * 100).round() : 0;
    return Row(
      children: [
        Container(
            width: 12,
            height: 12,
            decoration:
                BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text('$label  ',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurface)),
        Text('$value ($pct%)',
            style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface)),
      ],
    );
  }
}
