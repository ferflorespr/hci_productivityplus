import 'package:flutter/material.dart';

import '../models/goal.dart';
import '../state/goal_store.dart';
import 'edit_goal_page.dart';

class GoalView extends StatelessWidget {
  const GoalView({
    super.key,
    required this.goalId,
    required this.store,
  });

  final String goalId;
  final GoalStore store;

  Goal? _find() =>
      store.goals.where((g) => g.id == goalId).firstOrNull;

  void _openEdit(BuildContext context, Goal goal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditGoalPage(goal: goal, onSubmit: store.update),
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
    return ListenableBuilder(
      listenable: store,
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
