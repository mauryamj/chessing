import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleSignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF131314) : Colors.white;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: isDark ? const Color(0xFFE3E3E3) : const Color(0xFF1F1F1F),
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: isDark ? const Color(0xFF444746) : const Color(0xFF747775),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomPaint(
            size: const Size(18, 18),
            painter: _GoogleGLogoPainter(cutoutColor: bgColor),
          ),
          const SizedBox(width: 12),
          const Text(
            'Continue with Google',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }
}

class _GoogleGLogoPainter extends CustomPainter {
  final Color cutoutColor;

  _GoogleGLogoPainter({required this.cutoutColor});

  @override
  void paint(Canvas canvas, Size size) {
    final double r = size.width / 2;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Arcs representing the Google logo colors
    // Red (top)
    canvas.drawArc(rect, -3.1415 * 0.95, 3.1415 * 0.7, true, Paint()..color = const Color(0xFFEA4335));
    // Blue (right)
    canvas.drawArc(rect, -3.1415 * 0.25, 3.1415 * 0.5, true, Paint()..color = const Color(0xFF4285F4));
    // Green (bottom)
    canvas.drawArc(rect, 3.1415 * 0.25, 3.1415 * 0.55, true, Paint()..color = const Color(0xFF34A853));
    // Yellow (left)
    canvas.drawArc(rect, 3.1415 * 0.8, 3.1415 * 0.4, true, Paint()..color = const Color(0xFFFBBC05));

    // Inner cutout to make it a ring
    canvas.drawCircle(Offset(r, r), r * 0.6, Paint()..color = cutoutColor);
    
    // Draw G mouth cutout and horizontal bar
    // Cutout slice: from 0 to 45 degrees
    final cutoutPath = Path()
      ..moveTo(r, r)
      ..lineTo(size.width, r)
      ..arcTo(rect, 0, 3.1415 * 0.25, false)
      ..close();
    canvas.drawPath(cutoutPath, Paint()..color = cutoutColor);

    // Blue horizontal bar
    final barRect = Rect.fromLTWH(r, r - r * 0.2, r, r * 0.4);
    canvas.drawRect(barRect, Paint()..color = const Color(0xFF4285F4));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
