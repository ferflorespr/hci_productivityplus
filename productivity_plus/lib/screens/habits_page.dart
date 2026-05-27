import 'package:flutter/material.dart';

import '../models/goal.dart';
import '../models/habit.dart';
import '../state/goal_store.dart';
import '../state/habit_store.dart';
import '../widgets/app_logo.dart';
import 'create_habit_page.dart';
import 'edit_habit_page.dart';

class HabitsPage extends StatelessWidget {
  const HabitsPage({super.key, required this.store, this.goalStore});

  final HabitStore store;
  final GoalStore? goalStore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: store,
          builder: (context, _) {
            final habits = store.habits;
            return Column(
              children: [
                const AppLogo(height: 180),
                Text(
                  'Habits',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: habits.isEmpty
                      ? const _EmptyState()
                      : _HabitList(
                          habits: habits,
                          goalStore: goalStore,
                          onTapHabit: (h) => _openEdit(context, h),
                        ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        heroTag: 'add_habit_fab',
        onPressed: () => _openCreate(context),
        tooltip: 'Add habit',
        child: const Icon(Icons.add, size: 36),
      ),
    );
  }

  void _openCreate(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CreateHabitPage(
          onSubmit: store.add,
          goalStore: goalStore,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  void _openEdit(BuildContext context, Habit habit) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditHabitPage(
          habit: habit,
          onSubmit: store.update,
          goalStore: goalStore,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'No habits yet',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to create your first habit.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HabitList extends StatelessWidget {
  const _HabitList({
    required this.habits,
    required this.onTapHabit,
    this.goalStore,
  });

  final List<Habit> habits;
  final void Function(Habit) onTapHabit;
  final GoalStore? goalStore;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
      itemCount: habits.length,
      itemBuilder: (context, i) {
        final habit = habits[i];
        final linkedGoal = (habit.goalId != null && goalStore != null)
            ? goalStore!.goals
                .where((g) => g.id == habit.goalId)
                .firstOrNull
            : null;
        return _HabitTile(
          habit: habit,
          linkedGoal: linkedGoal,
          onTap: () => onTapHabit(habit),
        );
      },
    );
  }
}

class _HabitTile extends StatelessWidget {
  const _HabitTile({
    required this.habit,
    required this.onTap,
    this.linkedGoal,
  });

  final Habit habit;
  final VoidCallback onTap;
  final Goal? linkedGoal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initial = habit.title.isNotEmpty
        ? habit.title.characters.first.toUpperCase()
        : '?';

    final avatarBg = linkedGoal != null
        ? linkedGoal!.category.color.withAlpha(51)
        : theme.colorScheme.primaryContainer;
    final avatarFg = linkedGoal != null
        ? linkedGoal!.category.color
        : theme.colorScheme.onPrimaryContainer;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: avatarBg,
          foregroundColor: avatarFg,
          child: Text(initial, style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
        title: Text(
          habit.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(habit.scheduleEnabled ? habit.frequency.label : 'No schedule'),
            if (linkedGoal != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: linkedGoal!.category.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        linkedGoal!.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: linkedGoal!.category.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        isThreeLine: linkedGoal != null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (habit.remindersEnabled)
              Icon(
                Icons.notifications_active_outlined,
                size: 20,
                color: theme.colorScheme.primary,
              ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
