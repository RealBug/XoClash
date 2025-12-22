import 'package:flutter/material.dart';
import 'package:tictac/core/constants/app_constants.dart';

class RoundedSymbolPainter extends CustomPainter {

  RoundedSymbolPainter({
    required this.symbol,
    required this.color,
    required this.strokeWidth,
    this.usePathForX = false,
  });
  final String symbol;
  final Color color;
  final double strokeWidth;
  final bool usePathForX;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (symbol == AppConstants.defaultPlayerSymbolO) {
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        (size.width / 2) - strokeWidth / 2,
        paint,
      );
    } else {
      final double offset = strokeWidth / 2;
      if (usePathForX) {
        final Path path = Path()
          ..moveTo(offset, offset)
          ..lineTo(size.width - offset, size.height - offset)
          ..moveTo(size.width - offset, offset)
          ..lineTo(offset, size.height - offset);
        canvas.drawPath(path, paint);
      } else {
        canvas.drawLine(
          Offset(offset, offset),
          Offset(size.width - offset, size.height - offset),
          paint,
        );
        canvas.drawLine(
          Offset(size.width - offset, offset),
          Offset(offset, size.height - offset),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is! RoundedSymbolPainter) {
      return true;
    }
    return oldDelegate.symbol != symbol ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.usePathForX != usePathForX;
  }
}

class OutlineSymbolPainter extends CustomPainter {

  OutlineSymbolPainter({
    required this.symbol,
    required this.color,
    required this.strokeWidth,
    this.usePathForX = true,
    this.useCenterPoint = false,
  });
  final String symbol;
  final Color color;
  final double strokeWidth;
  final bool usePathForX;
  final bool useCenterPoint;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (symbol == AppConstants.defaultPlayerSymbolO) {
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        (size.width / 2) - strokeWidth / 2,
        paint,
      );
    } else {
      final double offset = strokeWidth / 2;
      if (usePathForX) {
        if (useCenterPoint) {
          final Path path = Path()
            ..moveTo(offset, offset)
            ..lineTo(size.width / 2, size.height / 2)
            ..lineTo(offset, size.height - offset)
            ..moveTo(size.width - offset, offset)
            ..lineTo(size.width / 2, size.height / 2)
            ..lineTo(size.width - offset, size.height - offset);
          canvas.drawPath(path, paint);
        } else {
          final Path path = Path()
            ..moveTo(offset, offset)
            ..lineTo(size.width - offset, size.height - offset)
            ..moveTo(size.width - offset, offset)
            ..lineTo(offset, size.height - offset);
          canvas.drawPath(path, paint);
        }
      } else {
        canvas.drawLine(
          Offset(offset, offset),
          Offset(size.width - offset, size.height - offset),
          paint,
        );
        canvas.drawLine(
          Offset(size.width - offset, offset),
          Offset(offset, size.height - offset),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is! OutlineSymbolPainter) {
      return true;
    }
    return oldDelegate.symbol != symbol ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.usePathForX != usePathForX ||
        oldDelegate.useCenterPoint != useCenterPoint;
  }
}


