import 'package:flutter/material.dart';

class ClockWidget extends StatelessWidget {
  final Duration duration;
  final bool isActive;
  final String label;

  const ClockWidget({
    super.key,
    required this.duration,
    required this.isActive,
    required this.label,
  });

  String _formatDuration(Duration d) {
    if (d <= Duration.zero) return '00:00';
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLowTime = duration.inSeconds < 10 && duration.inSeconds > 0;
    
    Color backgroundColor;
    Color textColor;
    
    if (isActive) {
      if (isLowTime) {
        backgroundColor = theme.colorScheme.errorContainer;
        textColor = theme.colorScheme.onErrorContainer;
      } else {
        backgroundColor = theme.colorScheme.primaryContainer;
        textColor = theme.colorScheme.onPrimaryContainer;
      }
    } else {
      backgroundColor = theme.cardTheme.color ?? theme.colorScheme.surface;
      textColor = theme.textTheme.bodyMedium?.color?.withOpacity(0.6) ?? Colors.grey;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isActive
              ? (isLowTime ? theme.colorScheme.error : theme.colorScheme.primary)
              : Colors.transparent,
          width: 2,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: (isLowTime ? theme.colorScheme.error : theme.colorScheme.primary)
                      .withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ]
            : [],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.alarm_on : Icons.alarm,
            size: 16,
            color: textColor,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: textColor.withOpacity(0.7),
                ),
              ),
              Text(
                _formatDuration(duration),
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
