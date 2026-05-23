import 'package:flutter/material.dart';

import '../models/habit.dart';
import '../state/habit_store.dart';
import '../widgets/app_logo.dart';
import 'create_habit_page.dart';
import 'edit_habit_page.dart';

class HabitsPage extends StatelessWidget {
  const HabitsPage({super.key, required this.store});

  final HabitStore store;

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
        builder: (_) => CreateHabitPage(onSubmit: store.add),
        fullscreenDialog: true,
      ),
    );
  }

  void _openEdit(BuildContext context, Habit habit) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditHabitPage(habit: habit, onSubmit: store.update),
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
  const _HabitList({required this.habits, required this.onTapHabit});

  final List<Habit> habits;
  final void Function(Habit) onTapHabit;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // Bottom padding so the last item isn't tucked under the FAB.
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
      itemCount: habits.length,
      itemBuilder: (context, i) => _HabitTile(
        habit: habits[i],
        onTap: () => onTapHabit(habits[i]),
      ),
    );
  }
}

class _HabitTile extends StatelessWidget {
  const _HabitTile({required this.habit, required this.onTap});

  final Habit habit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitle = habit.scheduleEnabled
        ? habit.frequency.label
        : 'No schedule';
    final initial = habit.title.isNotEmpty
        ? habit.title.characters.first.toUpperCase()
        : '?';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          foregroundColor: theme.colorScheme.onPrimaryContainer,
          child: Text(initial, style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
        title: Text(
          habit.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(subtitle),
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
