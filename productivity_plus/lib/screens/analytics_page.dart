import 'package:flutter/material.dart';

import '../widgets/analytics/analytics_calendar.dart';
import '../widgets/analytics/analytics_pie_chart.dart';
import '../widgets/analytics/task_slice.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  DateTime selectedDate = DateTime(2026, 5, 31);

  final Map<DateTime, List<TaskSlice>> tasksByDate = {
    DateTime(2026, 5, 31): [
      const TaskSlice('Habits', 5),
      const TaskSlice('Goals', 2),
      const TaskSlice('Journal', 1),
    ],
    DateTime(2026, 5, 30): [
      const TaskSlice('Habits', 2),
      const TaskSlice('Goals', 3),
      const TaskSlice('Journal', 1),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final slices =
        tasksByDate[selectedDate] ?? [];

    final totalDone = slices.fold(
      0,
      (sum, item) => sum + item.count,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AnalyticsCalendar(
            selectedDate: selectedDate,
            tasksByDate: tasksByDate,
            onDateSelected: (date) {
              setState(() {
                selectedDate = date;
              });
            },
          ),
          const SizedBox(height: 20),
          AnalyticsPieChart(
            slices: slices,
            totalDone: totalDone,
          ),
        ],
      ),
    );
  }
}
