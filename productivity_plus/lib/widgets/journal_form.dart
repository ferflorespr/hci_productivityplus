import 'package:flutter/material.dart';

import '../models/journal_entry.dart';
import '../state/goal_store.dart';
import 'goal_link_dropdown.dart';
import 'section_label.dart';

class JournalForm extends StatefulWidget {
  const JournalForm({
    super.key,
    this.initial,
    this.goalStore,
    required this.submitLabel,
    required this.onSubmit,
  });

  final JournalEntry? initial;
  final GoalStore? goalStore;
  final String submitLabel;
  final void Function(JournalEntry) onSubmit;

  @override
  State<JournalForm> createState() => _JournalFormState();
}

class _JournalFormState extends State<JournalForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late DateTime _date;
  late String? _goalId;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _titleController = TextEditingController(text: initial?.title ?? '');
    _contentController = TextEditingController(text: initial?.content ?? '');
    _date = initial?.date ?? DateTime.now();
    _goalId = initial?.goalId;
    _titleController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  bool get _canSubmit => _titleController.text.trim().isNotEmpty;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  void _handleSubmit() {
    final base = widget.initial ??
        JournalEntry(
          id: JournalEntry.newId(),
          title: '',
          date: _date,
          content: '',
        );
    final entry = base.copyWith(
      title: _titleController.text.trim(),
      date: _date,
      content: _contentController.text,
      goalId: () => _goalId,
    );
    widget.onSubmit(entry);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionLabel('Title'),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Entry title',
                  hintText: 'e.g. Morning reflection',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const SectionLabel('Date'),
              const SizedBox(height: 8),
              Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  leading: const Icon(Icons.event_outlined),
                  title: const Text('Date'),
                  subtitle: Text(formatDate(_date)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _pickDate,
                ),
              ),
              if (widget.goalStore != null &&
                  widget.goalStore!.goals.isNotEmpty) ...[
                const SizedBox(height: 20),
                const SectionLabel('Link to Goal'),
                const SizedBox(height: 8),
                GoalLinkDropdown(
                  goalStore: widget.goalStore!,
                  selectedGoalId: _goalId,
                  onChanged: (id) => setState(() => _goalId = id),
                ),
              ],
              const SizedBox(height: 20),
              const SectionLabel('Entry'),
              const SizedBox(height: 8),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _contentController,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                hintText: 'Write your entry…',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: _canSubmit ? _handleSubmit : null,
                style: FilledButton.styleFrom(
                  textStyle: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: Text(widget.submitLabel),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

String formatDate(DateTime d) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${months[d.month - 1]} ${d.day}, ${d.year}';
}
