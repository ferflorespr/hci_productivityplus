import 'package:flutter/material.dart';

import '../models/habit.dart';
import '../state/goal_store.dart';
import '../state/habit_store.dart';
import '../state/journal_store.dart';
import '../widgets/analytics/analytics_pie_chart.dart';
import '../widgets/analytics/task_slice.dart';
import '../widgets/journal_form.dart' show formatDate;

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key, this.goalStore, this.habitStore, this.journalStore});

  final GoalStore? goalStore;
  final HabitStore? habitStore;
  final JournalStore? journalStore;

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  late DateTime _calendarMonth = DateTime(DateTime.now().year, DateTime.now().month);

  @override
  Widget build(BuildContext context) {
    final stores = [widget.goalStore, widget.habitStore, widget.journalStore]
        .whereType<Listenable>()
        .toList();
    if (stores.isEmpty) return _buildContent(context);
    return ListenableBuilder(
      listenable: Listenable.merge(stores),
      builder: (context, _) => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final goals = widget.goalStore?.goals ?? [];
    final habits = widget.habitStore?.habits ?? [];
    final entries = widget.journalStore?.entries ?? [];

    final goalSlices = <TaskSlice>[];
    final categoryMap = <String, ({int count, Color color})>{};
    for (final g in goals) {
      final key = g.category.label;
      categoryMap[key] = (count: (categoryMap[key]?.count ?? 0) + 1, color: g.category.color);
    }
    for (final e in categoryMap.entries) {
      goalSlices.add(TaskSlice(e.key, e.value.count, color: e.value.color));
    }

    final dailyCount = habits.where((h) => h.frequency == HabitFrequency.daily).length;
    final weeklyCount = habits.where((h) => h.frequency == HabitFrequency.weekly).length;
    final monthlyCount = habits.where((h) => h.frequency == HabitFrequency.monthly).length;

    final daysWithEntries = entries
        .map((e) => DateTime(e.date.year, e.date.month, e.date.day))
        .toSet();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 48),
          children: [

            // ── Header ───────────────────────────────────────────────────────
            Text('Analytics', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(_formatMonthYear(DateTime.now()), style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
            const SizedBox(height: 32),

            // ── Stats row — big numbers, no cards ────────────────────────────
            IntrinsicHeight(
              child: Row(
                children: [
                  _BigStat(value: goals.length, label: 'Goals', theme: theme),
                  VerticalDivider(width: 1, thickness: 1, color: cs.outlineVariant),
                  _BigStat(value: habits.length, label: 'Habits', theme: theme),
                  VerticalDivider(width: 1, thickness: 1, color: cs.outlineVariant),
                  _BigStat(value: entries.length, label: 'Entries', theme: theme),
                ],
              ),
            ),

            // ── Goals by category ────────────────────────────────────────────
            if (goals.isNotEmpty) ...[
              const SizedBox(height: 40),
              _sectionHeading('Goals by category', theme, cs),
              const SizedBox(height: 16),
              AnalyticsPieChart(slices: goalSlices, totalDone: goals.length),
            ],

            // ── Habits ───────────────────────────────────────────────────────
            if (habits.isNotEmpty) ...[
              const SizedBox(height: 40),
              _sectionHeading('Habits', theme, cs),
              const SizedBox(height: 4),
              Text('${habits.length} total', style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
              const SizedBox(height: 16),
              if (dailyCount > 0) _habitFrequencyRow('Daily', dailyCount, habits.length, const Color(0xFF4CAF50), theme),
              if (dailyCount > 0) const SizedBox(height: 12),
              if (weeklyCount > 0) _habitFrequencyRow('Weekly', weeklyCount, habits.length, const Color(0xFF42A5F5), theme),
              if (weeklyCount > 0) const SizedBox(height: 12),
              if (monthlyCount > 0) _habitFrequencyRow('Monthly', monthlyCount, habits.length, const Color(0xFFFFA726), theme),
            ],

            // ── Journal calendar ─────────────────────────────────────────────
            const SizedBox(height: 40),
            _sectionHeading('Journal activity', theme, cs),
            const SizedBox(height: 16),
            _CalendarView(
              theme: theme,
              month: _calendarMonth,
              daysWithEntries: daysWithEntries,
              onPrev: () => setState(() => _calendarMonth = DateTime(_calendarMonth.year, _calendarMonth.month - 1)),
              onNext: () => setState(() => _calendarMonth = DateTime(_calendarMonth.year, _calendarMonth.month + 1)),
            ),

            // ── Recent entries ───────────────────────────────────────────────
            if (entries.isNotEmpty) ...[
              const SizedBox(height: 40),
              _sectionHeading('Recent entries', theme, cs),
              const SizedBox(height: 16),
              ...entries.take(3).map((e) {
                final linkedGoal = widget.goalStore?.goals.where((g) => g.id == e.goalId).firstOrNull;
                return _TimelineEntry(
                  theme: theme,
                  title: e.title,
                  date: formatDate(e.date),
                  preview: e.content,
                  accentColor: linkedGoal?.category.color ?? cs.outlineVariant,
                  goalLabel: linkedGoal?.title,
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Big stat (no card) ─────────────────────────────────────────────────────────

class _BigStat extends StatelessWidget {
  const _BigStat({required this.value, required this.label, required this.theme});
  final int value;
  final String label;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('$value', style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

// ── Section heading ────────────────────────────────────────────────────────────

Widget _sectionHeading(String text, ThemeData theme, ColorScheme cs) {
  return Text(
    text.toUpperCase(),
    style: theme.textTheme.labelMedium?.copyWith(
      color: cs.onSurfaceVariant,
      letterSpacing: 1.2,
      fontWeight: FontWeight.w700,
    ),
  );
}

// ── Habit frequency row ────────────────────────────────────────────────────────

Widget _habitFrequencyRow(String label, int count, int total, Color color, ThemeData theme) {
  final fraction = total == 0 ? 0.0 : count / total;
  return Row(
    children: [
      Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
      const SizedBox(width: 12),
      SizedBox(width: 60, child: Text(label, style: theme.textTheme.bodyMedium)),
      const SizedBox(width: 12),
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 6,
            backgroundColor: color.withAlpha(25),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ),
      const SizedBox(width: 12),
      Text('$count', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: color)),
    ],
  );
}

// ── Calendar ───────────────────────────────────────────────────────────────────

class _CalendarView extends StatelessWidget {
  const _CalendarView({required this.theme, required this.month, required this.daysWithEntries, required this.onPrev, required this.onNext});

  final ThemeData theme;
  final DateTime month;
  final Set<DateTime> daysWithEntries;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final cs = theme.colorScheme;
    final firstDay = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leadingBlanks = firstDay.weekday % 7;
    final today = DateTime.now();

    final cells = [
      ...List<DateTime?>.filled(leadingBlanks, null),
      ...List.generate(daysInMonth, (i) => DateTime(month.year, month.month, i + 1)),
    ];

    const weekdays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(_formatMonthYear(month), style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            const Spacer(),
            GestureDetector(onTap: onPrev, child: Icon(Icons.chevron_left, size: 20, color: cs.onSurfaceVariant)),
            const SizedBox(width: 8),
            GestureDetector(onTap: onNext, child: Icon(Icons.chevron_right, size: 20, color: cs.onSurfaceVariant)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: weekdays.map((d) => Expanded(
            child: Center(child: Text(d, style: theme.textTheme.labelSmall?.copyWith(color: cs.onSurfaceVariant))),
          )).toList(),
        ),
        const SizedBox(height: 6),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          children: cells.map((date) {
            if (date == null) return const SizedBox.shrink();
            final isToday = date.year == today.year && date.month == today.month && date.day == today.day;
            final hasEntry = daysWithEntries.contains(date);
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isToday ? cs.primary : Colors.transparent,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    '${date.day}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isToday ? cs.onPrimary : cs.onSurface,
                      fontWeight: isToday ? FontWeight.w700 : FontWeight.normal,
                    ),
                  ),
                  if (hasEntry && !isToday)
                    Positioned(
                      bottom: 4,
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFA726),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ── Timeline entry ─────────────────────────────────────────────────────────────

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({required this.theme, required this.title, required this.date, required this.preview, required this.accentColor, this.goalLabel});

  final ThemeData theme;
  final String title;
  final String date;
  final String preview;
  final Color accentColor;
  final String? goalLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 3, height: 64, decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(99))),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                const SizedBox(height: 2),
                Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                if (preview.trim().isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(preview, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helpers ────────────────────────────────────────────────────────────────────

String _formatMonthYear(DateTime d) {
  const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  return '${months[d.month - 1]} ${d.year}';
}
