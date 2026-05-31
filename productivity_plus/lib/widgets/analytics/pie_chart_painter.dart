import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'task_slice.dart';

class PieChartPainter extends CustomPainter {
  PieChartPainter(this.slices);

  final List<TaskSlice> slices;

  @override
  void paint(Canvas canvas, Size size) {
    final total = slices.fold<int>(0, (sum, item) => sum + item.count);

    final rect = Offset.zero & size;
    final paint = Paint()..style = PaintingStyle.fill;

    if (total == 0) {
      paint.color = Colors.grey.shade300;
      canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);
      return;
    }

    double startAngle = -math.pi / 2;

    for (final slice in slices) {
      final sweepAngle = (slice.count / total) * math.pi * 2;

      paint.color = slice.color;
      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }

    paint.color = Colors.white;
    canvas.drawCircle(
      size.center(Offset.zero),
      size.width * .28,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant PieChartPainter oldDelegate) {
    return oldDelegate.slices != slices;
  }
}