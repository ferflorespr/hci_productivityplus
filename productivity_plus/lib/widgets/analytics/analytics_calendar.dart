import 'package:flutter/material.dart';

import 'task_slice.dart';

class AnalyticsCalendar extends StatelessWidget {
  const AnalyticsCalendar({
    super.key,
    required this.selectedDate,
    required this.tasksByDate,
    required this.onDateSelected,
  });

  final DateTime selectedDate;
  final Map<DateTime, List<TaskSlice>> tasksByDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final firstDayOfMonth = DateTime(2026, 5, 1);
    final daysInMonth = DateTime(2026, 6, 0).day;
    final leadingEmptyDays = firstDayOfMonth.weekday % 7;

    final calendarCells = [
      ...List<DateTime?>.filled(leadingEmptyDays, null),
      ...List.generate(
        daysInMonth,
        (index) => DateTime(2026, 5, index + 1),
      ),
    ];

    const weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'May 2026',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: weekdays.map((day) {
                return Center(
                  child: Text(
                    day,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 8),

            GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: calendarCells.map((date) {
                if (date == null) {
                  return const SizedBox.shrink();
                }

                final isSelected = _isSameDay(date, selectedDate);
                final hasData = tasksByDate.keys.any(
                  (taskDate) => _isSameDay(taskDate, date),
                );

                return InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () => onDateSelected(date),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : hasData
                              ? theme.colorScheme.primaryContainer
                              : Colors.transparent,
                    ),
                    child: Center(
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          color: isSelected
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface,
                          fontWeight:
                              hasData ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}