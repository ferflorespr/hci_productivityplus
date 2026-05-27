import 'package:flutter/material.dart';

import '../models/goal.dart';
import '../state/goal_store.dart';
import '../widgets/app_logo.dart';
import 'create_goal_page.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key, required this.store});

  final GoalStore store;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: store,
          builder: (context, _) {
            final goals = store.goals;
            return Column(
              children: [
                const AppLogo(height: 180),
                Text(
                  'Goals',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: goals.isEmpty
                      ? const _EmptyState()
                      : _GoalList(goals: goals),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        heroTag: 'add_goal_fab',
        onPressed: () => _openCreate(context),
        tooltip: 'Add goal',
        child: const Icon(Icons.add, size: 36),
      ),
    );
  }

  void _openCreate(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CreateGoalPage(onSubmit: store.add),
        fullscreenDialog: true,
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
              'No goals yet',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to create your first goal.',
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

class _GoalList extends StatelessWidget {
  const _GoalList({required this.goals});

  final List<Goal> goals;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
      itemCount: goals.length,
      itemBuilder: (context, i) => _GoalTile(goal: goals[i]),
    );
  }
}

class _GoalTile extends StatelessWidget {
  const _GoalTile({required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initial = goal.title.isNotEmpty
        ? goal.title.characters.first.toUpperCase()
        : '?';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: goal.category.color.withAlpha(51),
          foregroundColor: goal.category.color,
          child: Text(
            initial,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        title: Text(
          goal.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          goal.category.label,
          style: TextStyle(color: goal.category.color),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
