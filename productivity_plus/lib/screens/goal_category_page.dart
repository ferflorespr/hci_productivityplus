import 'package:flutter/material.dart';

import '../models/goal.dart';
import '../state/goal_store.dart';
import 'goal_view.dart';

class GoalCategoryPage extends StatelessWidget {
  const GoalCategoryPage({
    super.key,
    required this.category,
    required this.store,
  });

  final GoalCategory category;
  final GoalStore store;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: category.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                category.label,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final goals = store.goals
              .where((g) => g.category == category)
              .toList();
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
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            itemCount: goals.length,
            itemBuilder: (context, i) {
              final goal = goals[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  onTap: () => _openGoal(context, goal),
                  leading: CircleAvatar(
                    backgroundColor: category.color.withAlpha(51),
                    foregroundColor: category.color,
                    child: Text(
                      goal.title.isNotEmpty
                          ? goal.title.characters.first.toUpperCase()
                          : '?',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  title: Text(
                    goal.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: goal.targetDate != null
                      ? Text(_formatDate(goal.targetDate!))
                      : null,
                  trailing: Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _openGoal(BuildContext context, Goal goal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GoalView(goalId: goal.id, store: store),
      ),
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
