import 'dart:math';

import 'package:flutter/material.dart';

import '../models/goal.dart';
import '../state/goal_store.dart';
import '../state/habit_store.dart';
import '../state/journal_store.dart';
import '../widgets/journal_form.dart' show formatDate;
import 'edit_goal_page.dart';

class GoalView extends StatelessWidget {
  const GoalView({
    super.key,
    required this.goalId,
    required this.store,
    this.habitStore,
    this.journalStore,
  });

  final String goalId;
  final GoalStore store;
  final HabitStore? habitStore;
  final JournalStore? journalStore;

  Goal? _find() =>
      store.goals.where((g) => g.id == goalId).firstOrNull;

  void _openEdit(BuildContext context, Goal goal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditGoalPage(goal: goal, onSubmit: store.update),
      ),
    );
  }

  void _triggerLapse(BuildContext context) {
    store.triggerLapse(goalId, DateTime.now());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Momentum on hold — complete habits tomorrow to recover.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final theme = Theme.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete goal?'),
        content: const Text(
          "This will permanently delete this goal. This action can't be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!context.mounted) return;
    store.delete(goalId);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final listenable = habitStore != null
        ? Listenable.merge([store, habitStore!])
        : store;
    return ListenableBuilder(
      listenable: listenable,
      builder: (context, _) {
        final goal = _find();
        if (goal == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Goal not found.')),
          );
        }
        final theme = Theme.of(context);
        return Scaffold(
          appBar: AppBar(
            actions: [
              if (!goal.momentumOnHold)
                IconButton(
                  icon: const Icon(Icons.pause_circle_outline),
                  tooltip: 'Mark as missed today',
                  onPressed: () => _triggerLapse(context),
                ),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit goal',
                onPressed: () => _openEdit(context, goal),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Delete goal',
                onPressed: () => _confirmDelete(context),
              ),
            ],
          ),
          body: SafeArea(
            top: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                Text(
                  goal.title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: goal.category.color.withAlpha(38),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: goal.category.color.withAlpha(100),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            goal.category.icon,
                            size: 16,
                            color: goal.category.color,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            goal.category.label,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: goal.category.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // ── Streak chip ──────────────────────────────────────────
                if (goal.streakDays > 0) ...[
                  const SizedBox(height: 12),
                  _StreakChip(streakDays: goal.streakDays, onHold: goal.momentumOnHold),
                ],

                // ── Recovery banner ──────────────────────────────────────
                if (goal.momentumOnHold && habitStore != null) ...[
                  const SizedBox(height: 16),
                  _RecoveryBanner(
                    goal: goal,
                    habitStore: habitStore!,
                    onRecover: () => store.recoverMomentum(goalId),
                    onReset: () => store.resetStreak(goalId),
                  ),
                ],

                if (goal.targetDate != null) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.event_outlined,
                        size: 20,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Target: ${_formatDate(goal.targetDate!)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
                if (goal.description.trim().isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    goal.description,
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
                if (habitStore != null) ...[
                  const SizedBox(height: 28),
                  Text('Habits', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  ...() {
                    final linked = habitStore!.habits.where((h) => h.goalId == goalId).toList();
                    if (linked.isEmpty) {
                      return [Text('No habits linked to this goal.', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant))];
                    }
                    return linked.map((h) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.repeat_rounded),
                        title: Text(h.title),
                        subtitle: Text(h.scheduleEnabled ? h.frequency.label : 'No schedule'),
                      ),
                    )).toList();
                  }(),
                ],
                if (journalStore != null) ...[
                  const SizedBox(height: 28),
                  Text('Journal Entries', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  ...() {
                    final linked = journalStore!.entries.where((e) => e.goalId == goalId).toList();
                    if (linked.isEmpty) {
                      return [Text('No journal entries linked to this goal.', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant))];
                    }
                    return linked.map((e) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.menu_book_rounded),
                        title: Text(e.title),
                        subtitle: Text(formatDate(e.date)),
                      ),
                    )).toList();
                  }(),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

String _formatDate(DateTime d) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${months[d.month - 1]} ${d.day}, ${d.year}';
}

// ── Streak chip ────────────────────────────────────────────────────────────────

class _StreakChip extends StatelessWidget {
  const _StreakChip({required this.streakDays, required this.onHold});

  final int streakDays;
  final bool onHold;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = onHold ? const Color(0xFFFFA726) : const Color(0xFF4CAF50);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withAlpha(30),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withAlpha(100)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                onHold ? Icons.pause_circle_rounded : Icons.local_fire_department_rounded,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 6),
              Text(
                onHold
                    ? '$streakDays-day streak (on hold)'
                    : '$streakDays-day streak',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Recovery banner ────────────────────────────────────────────────────────────

class _RecoveryBanner extends StatelessWidget {
  const _RecoveryBanner({
    required this.goal,
    required this.habitStore,
    required this.onRecover,
    required this.onReset,
  });

  final Goal goal;
  final HabitStore habitStore;
  final VoidCallback onRecover;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final linkedHabitIds = habitStore.habits
        .where((h) => h.goalId == goal.id)
        .map((h) => h.id)
        .toList();

    final totalHabits = linkedHabitIds.length;
    final today = DateTime.now();
    final completedToday = habitStore.countCompletedOn(linkedHabitIds, today);
    final threshold = max(1, (totalHabits * goal.recoveryThresholdPct).ceil());
    final thresholdMet = completedToday >= threshold;
    final progress = totalHabits == 0 ? 0.0 : completedToday / totalHabits;

    final lapseDateStr = goal.lapseDate != null ? _formatDate(goal.lapseDate!) : 'recently';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFA726).withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFA726).withAlpha(120)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Color(0xFFFFA726), size: 20),
              const SizedBox(width: 8),
              Text(
                'Momentum On Hold',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: const Color(0xFFFFA726),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Lapse detected on $lapseDateStr. Your $streakLabel streak is paused — not lost.',
            style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          if (totalHabits > 0) ...[
            Text(
              'Complete $threshold of $totalHabits habits today to recover:',
              style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: const Color(0xFFFFA726).withAlpha(40),
                valueColor: AlwaysStoppedAnimation<Color>(
                  thresholdMet ? const Color(0xFF4CAF50) : const Color(0xFFFFA726),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '$completedToday / $totalHabits completed today',
              style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: thresholdMet ? onRecover : null,
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('Recover Momentum'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    disabledBackgroundColor: cs.surfaceContainerHighest,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: onReset,
                style: TextButton.styleFrom(foregroundColor: cs.error),
                child: const Text('Reset Streak'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String get streakLabel => '${goal.streakDays}-day';
}
