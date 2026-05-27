import 'dart:async';

import 'package:flutter/material.dart';

import '../models/journal_entry.dart';
import '../state/goal_store.dart';
import '../state/journal_store.dart';
import '../widgets/journal_form.dart' show formatDate;
import 'edit_journal_page.dart';

/// iOS Notes–style entry view. Title and date are shown read-only at the top,
/// the body is an unbordered TextField that fills the rest of the screen and
/// saves automatically as the user types (debounced 300ms, with a final flush
/// on dispose so nothing is lost on a fast back-swipe).
class JournalEntryView extends StatefulWidget {
  const JournalEntryView({
    super.key,
    required this.entryId,
    required this.store,
    this.goalStore,
  });

  final String entryId;
  final JournalStore store;
  final GoalStore? goalStore;

  @override
  State<JournalEntryView> createState() => _JournalEntryViewState();
}

class _JournalEntryViewState extends State<JournalEntryView> {
  late final TextEditingController _controller;
  Timer? _saveDebounce;

  @override
  void initState() {
    super.initState();
    final entry = _findEntry();
    _controller = TextEditingController(text: entry?.content ?? '');
    _controller.addListener(_handleChange);
  }

  @override
  void dispose() {
    _saveDebounce?.cancel();
    _flushPending();
    _controller.removeListener(_handleChange);
    _controller.dispose();
    super.dispose();
  }

  JournalEntry? _findEntry() => widget.store.entries
      .where((e) => e.id == widget.entryId)
      .firstOrNull;

  void _handleChange() {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 300), _flushPending);
  }

  void _flushPending() {
    final entry = _findEntry();
    if (entry == null) return;
    if (entry.content == _controller.text) return;
    widget.store.update(entry.copyWith(content: _controller.text));
  }

  void _openMetaEdit(JournalEntry entry) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditJournalPage(
          entry: entry,
          onSubmit: widget.store.update,
          goalStore: widget.goalStore,
        ),
      ),
    );
  }

  Future<void> _confirmDelete() async {
    final theme = Theme.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete entry?'),
        content: const Text(
          "This will permanently delete this journal entry. This action can't be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!mounted) return;
    widget.store.delete(widget.entryId);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.store,
      builder: (context, _) {
        final entry = _findEntry();
        if (entry == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Entry not found.')),
          );
        }
        final theme = Theme.of(context);
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Delete entry',
                onPressed: _confirmDelete,
              ),
            ],
          ),
          body: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MetaEditPopup(
                    onEdit: () => _openMetaEdit(entry),
                    child: Text(
                      entry.title,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  _MetaEditPopup(
                    onEdit: () => _openMetaEdit(entry),
                    child: Text(
                      formatDate(entry.date),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  if (widget.goalStore != null && entry.goalId != null) ...[
                    Builder(builder: (context) {
                      final goal = widget.goalStore!.goals
                          .where((g) => g.id == entry.goalId)
                          .firstOrNull;
                      if (goal == null) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: goal.category.color.withAlpha(38),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: goal.category.color.withAlpha(100),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: goal.category.color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    goal.title,
                                    style:
                                        theme.textTheme.labelMedium?.copyWith(
                                      color: goal.category.color,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                  const SizedBox(height: 16),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Start writing…',
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MetaEditPopup extends StatelessWidget {
  const _MetaEditPopup({required this.onEdit, required this.child});

  final VoidCallback onEdit;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: '',
      position: PopupMenuPosition.under,
      offset: const Offset(0, 4),
      padding: EdgeInsets.zero,
      onSelected: (value) {
        if (value == 'edit') onEdit();
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.edit_outlined, size: 20),
              SizedBox(width: 8),
              Text('Edit'),
            ],
          ),
        ),
      ],
      child: child,
    );
  }
}
