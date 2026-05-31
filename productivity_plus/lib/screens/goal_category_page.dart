import 'package:flutter/material.dart';

import '../models/goal.dart';
import '../models/habit.dart';
import '../state/goal_store.dart';
import '../state/habit_store.dart';
import '../state/journal_store.dart';
import 'goal_view.dart';

class GoalCategoryPage extends StatelessWidget {
  const GoalCategoryPage({
    super.key,
    required this.category,
    required this.store,
    this.habitStore,
    this.journalStore,
  });

  final GoalCategory category;
  final GoalStore store;
  final HabitStore? habitStore;
  final JournalStore? journalStore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final listenables = [store, habitStore];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(category.icon, color: category.color, size: 22),
            const SizedBox(width: 8),
            Flexible(
              child: Text(category.label, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge(listenables),
        builder: (context, _) {
          final goals = store.goals.where((g) => g.category == category).toList();
          final habits = habitStore == null
              ? <Habit>[]
              : habitStore!.habits.where((h) {
                  if (h.goalId == null) return false;
                  return goals.any((g) => g.id == h.goalId);
                }).toList();

          if (goals.isEmpty) {
            return Center(
              child: Text(
                'No goals in this category.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              // Goals section
              Text('Goals', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              ...goals.map((goal) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  onTap: () => _openGoal(context, goal),
                  leading: CircleAvatar(
                    backgroundColor: category.color.withAlpha(51),
                    foregroundColor: category.color,
                    child: Text(
                      goal.title.isNotEmpty ? goal.title.characters.first.toUpperCase() : '?',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  title: Text(goal.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  subtitle: goal.targetDate != null ? Text(_formatDate(goal.targetDate!)) : null,
                  trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
                ),
              )),
              const SizedBox(height: 20),
              // Habits section
              Text('Habits', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              if (habits.isEmpty)
                Text(
                  'No habits linked to goals in this category.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                )
              else
                ...habits.map((habit) {
                  final linkedGoal = goals.where((g) => g.id == habit.goalId).firstOrNull;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: category.color.withAlpha(51),
                        child: Icon(Icons.repeat_rounded, color: category.color),
                      ),
                      title: Text(habit.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(habit.scheduleEnabled ? habit.frequency.label : 'No schedule'),
                          if (linkedGoal != null)
                            Text(
                              linkedGoal.title,
                              style: theme.textTheme.bodySmall?.copyWith(color: category.color),
                            ),
                        ],
                      ),
                      isThreeLine: linkedGoal != null,
                      trailing: habit.remindersEnabled
                          ? Icon(Icons.notifications_active_outlined, size: 20, color: theme.colorScheme.primary)
                          : null,
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }

  void _openGoal(BuildContext context, Goal goal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GoalView(
          goalId: goal.id,
          store: store,
          habitStore: habitStore,
          journalStore: journalStore,
        ),
      ),
    );
  }
}

String _formatDate(DateTime d) {
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${months[d.month - 1]} ${d.day}, ${d.year}';
}
