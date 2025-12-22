import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:tictac/core/theme/app_theme.dart';

class CosmicBackground extends StatelessWidget {

  const CosmicBackground({
    super.key,
    required this.child,
    this.isDarkMode = true,
  });
  final Widget child;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color(0xFF0F0A1F),
                    Color(0xFF1A1230),
                    Color(0xFF0F0A1F),
                  ],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color(0xFFE8EDF5),
                    Color(0xFFF0F4F9),
                    Color(0xFFE6EBF2),
                    Color(0xFFE8EDF5),
                  ],
                  stops: <double>[0.0, 0.3, 0.7, 1.0],
                ),
        ),
        child: Stack(
          children: <Widget>[
            RepaintBoundary(
              child: IgnorePointer(
                child: _StarField(isDarkMode: isDarkMode),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

class _StarField extends StatelessWidget {

  const _StarField({required this.isDarkMode});
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _StarFieldPainter(isDarkMode: isDarkMode),
      size: Size.infinite,
    );
  }
}

class _StarFieldPainter extends CustomPainter {

  _StarFieldPainter({required this.isDarkMode});
  final bool isDarkMode;

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);

    if (isDarkMode) {
      final paint = Paint()
        ..color = AppTheme.darkTextPrimary.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill;

      for (var i = 0; i < 70; i++) {
        final x = random.nextDouble() * size.width;
        final y = random.nextDouble() * size.height;
        final radius = random.nextDouble() * 1.5 + 0.5;
        canvas.drawCircle(Offset(x, y), radius, paint);
      }

      final dotPaint = Paint()
        ..color = AppTheme.darkTextPrimary.withValues(alpha: 0.15)
        ..style = PaintingStyle.fill;

      for (var i = 0; i < 30; i++) {
        final x = random.nextDouble() * size.width;
        final y = random.nextDouble() * size.height;
        final radius = random.nextDouble() * 2 + 1;
        canvas.drawCircle(Offset(x, y), radius, dotPaint);
      }
    } else {
      final paint = Paint()
        ..color = const Color(0xFF6B7280).withValues(alpha: 0.25)
        ..style = PaintingStyle.fill;

      for (var i = 0; i < 60; i++) {
        final x = random.nextDouble() * size.width;
        final y = random.nextDouble() * size.height;
        final radius = random.nextDouble() * 1.5 + 0.5;
        canvas.drawCircle(Offset(x, y), radius, paint);
      }

      final dotPaint = Paint()
        ..color = const Color(0xFF9CA3AF).withValues(alpha: 0.15)
        ..style = PaintingStyle.fill;

      for (var i = 0; i < 35; i++) {
        final x = random.nextDouble() * size.width;
        final y = random.nextDouble() * size.height;
        final radius = random.nextDouble() * 2 + 1;
        canvas.drawCircle(Offset(x, y), radius, dotPaint);
      }

      final accentPaint = Paint()
        ..color = const Color(0xFFE63946).withValues(alpha: 0.12)
        ..style = PaintingStyle.fill;

      for (var i = 0; i < 15; i++) {
        final x = random.nextDouble() * size.width;
        final y = random.nextDouble() * size.height;
        final radius = random.nextDouble() * 2.5 + 1.5;
        canvas.drawCircle(Offset(x, y), radius, accentPaint);
      }

      final largePaint = Paint()
        ..color = const Color(0xFF4B5563).withValues(alpha: 0.08)
        ..style = PaintingStyle.fill;

      for (var i = 0; i < 8; i++) {
        final x = random.nextDouble() * size.width;
        final y = random.nextDouble() * size.height;
        final radius = random.nextDouble() * 3 + 2;
        canvas.drawCircle(Offset(x, y), radius, largePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
