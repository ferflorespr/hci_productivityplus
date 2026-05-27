import 'package:flutter/material.dart';

import '../models/goal.dart';
import '../models/journal_entry.dart';
import '../state/goal_store.dart';
import '../state/journal_store.dart';
import '../widgets/app_logo.dart';
import '../widgets/journal_form.dart' show formatDate;
import 'create_journal_page.dart';
import 'journal_entry_view.dart';

class JournalPage extends StatelessWidget {
  const JournalPage({super.key, required this.store, this.goalStore});

  final JournalStore store;
  final GoalStore? goalStore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: store,
          builder: (context, _) {
            final entries = store.entries;
            return Column(
              children: [
                const AppLogo(height: 180),
                Text(
                  'Journal',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: entries.isEmpty
                      ? const _EmptyState()
                      : _EntryList(
                          entries: entries,
                          goalStore: goalStore,
                          onTapEntry: (e) => _openView(context, e),
                        ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        heroTag: 'add_entry_fab',
        onPressed: () => _openCreate(context),
        tooltip: 'Add entry',
        child: const Icon(Icons.add, size: 36),
      ),
    );
  }

  void _openCreate(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CreateJournalPage(
          onSubmit: store.add,
          goalStore: goalStore,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  void _openView(BuildContext context, JournalEntry entry) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => JournalEntryView(
          entryId: entry.id,
          store: store,
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
              'No entries yet',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to write your first entry.',
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

class _EntryList extends StatelessWidget {
  const _EntryList({
    required this.entries,
    required this.onTapEntry,
    this.goalStore,
  });

  final List<JournalEntry> entries;
  final void Function(JournalEntry) onTapEntry;
  final GoalStore? goalStore;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
      itemCount: entries.length,
      itemBuilder: (context, i) {
        final entry = entries[i];
        final linkedGoal = (entry.goalId != null && goalStore != null)
            ? goalStore!.goals
                .where((g) => g.id == entry.goalId)
                .firstOrNull
            : null;
        return _EntryTile(
          entry: entry,
          linkedGoal: linkedGoal,
          onTap: () => onTapEntry(entry),
        );
      },
    );
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile({
    required this.entry,
    required this.onTap,
    this.linkedGoal,
  });

  final JournalEntry entry;
  final VoidCallback onTap;
  final Goal? linkedGoal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color avatarBg;
    final Widget avatarChild;
    if (linkedGoal != null) {
      avatarBg = linkedGoal!.category.color.withAlpha(51);
      avatarChild = Icon(linkedGoal!.category.icon, color: linkedGoal!.category.color);
    } else {
      avatarBg = Colors.grey.shade200;
      avatarChild = Icon(Icons.star_rounded, color: Colors.grey.shade400);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: avatarBg,
          child: avatarChild,
        ),
        title: Text(
          entry.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(formatDate(entry.date)),
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
            if (entry.content.trim().isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                entry.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        isThreeLine: true,
      ),
    );
  }
}
