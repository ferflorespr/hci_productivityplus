import 'package:flutter/material.dart';

import 'legend_row.dart';
import 'pie_chart_painter.dart';
import 'task_slice.dart';

class AnalyticsPieChart extends StatelessWidget {
  const AnalyticsPieChart({
    super.key,
    required this.slices,
    required this.totalDone,
  });

  final List<TaskSlice> slices;
  final int totalDone;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              height: 220,
              width: 220,
              child: CustomPaint(
                painter: PieChartPainter(slices),
                child: Center(
                  child: Text(
                    '$totalDone',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ...slices.map(
              (slice) => LegendRow(slice: slice),
            ),
          ],
        ),
      ),
    );
  }
}