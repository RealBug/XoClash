import 'dart:math' as math;
import 'package:flutter/material.dart';

class WinningLinePainter extends CustomPainter {

  WinningLinePainter({
    required this.startRow,
    required this.startCol,
    required this.endRow,
    required this.endCol,
    required this.boardSize,
    required this.cellSize,
    required this.cellMargin,
    required this.color,
    required this.progress,
  });
  final int startRow;
  final int startCol;
  final int endRow;
  final int endCol;
  final int boardSize;
  final double cellSize;
  final double cellMargin;
  final Color color;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final double cellSpacing = cellSize + (cellMargin * 2);
    const double containerPadding = 8.0;

    final double totalBoardWidth = boardSize * cellSize + boardSize * (cellMargin * 2);
    final double totalBoardHeight =
        boardSize * cellSize + boardSize * (cellMargin * 2);

    final double contentWidth = size.width - (containerPadding * 2);
    final double contentHeight = size.height - (containerPadding * 2);

    final double boardStartX = containerPadding + (contentWidth - totalBoardWidth) / 2;
    final double boardStartY =
        containerPadding + (contentHeight - totalBoardHeight) / 2;

    final double centerStartX =
        boardStartX + (startCol * cellSpacing) + cellMargin + (cellSize / 2);
    final double centerStartY =
        boardStartY + (startRow * cellSpacing) + cellMargin + (cellSize / 2);
    final double centerEndX =
        boardStartX + (endCol * cellSpacing) + cellMargin + (cellSize / 2);
    final double centerEndY =
        boardStartY + (endRow * cellSpacing) + cellMargin + (cellSize / 2);

    final double dx = centerEndX - centerStartX;
    final double dy = centerEndY - centerStartY;
    final double distance = math.sqrt(dx * dx + dy * dy);
    final double extension = cellSize * 0.3;

    final double startX = distance > 0
        ? centerStartX - (dx / distance) * extension
        : centerStartX;
    final double startY = distance > 0
        ? centerStartY - (dy / distance) * extension
        : centerStartY;
    final double endX =
        distance > 0 ? centerEndX + (dx / distance) * extension : centerEndX;
    final double endY =
        distance > 0 ? centerEndY + (dy / distance) * extension : centerEndY;

    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final double currentEndX = startX + (endX - startX) * progress;
    final double currentEndY = startY + (endY - startY) * progress;

    canvas.drawLine(
      Offset(startX, startY),
      Offset(currentEndX, currentEndY),
      paint,
    );

    final Paint glowPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawLine(
      Offset(startX, startY),
      Offset(currentEndX, currentEndY),
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
