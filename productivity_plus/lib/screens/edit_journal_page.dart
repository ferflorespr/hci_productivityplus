import 'package:flutter/material.dart';

import '../models/journal_entry.dart';
import '../state/goal_store.dart';
import '../widgets/goal_link_dropdown.dart';
import '../widgets/journal_form.dart' show formatDate;
import '../widgets/section_label.dart';

/// Edits only the title and date of an existing entry. The content body is
/// edited inline in [JournalEntryView] (auto-saved), so it doesn't appear here.
class EditJournalPage extends StatefulWidget {
  const EditJournalPage({
    super.key,
    required this.entry,
    required this.onSubmit,
    this.goalStore,
  });

  final JournalEntry entry;
  final void Function(JournalEntry) onSubmit;
  final GoalStore? goalStore;

  @override
  State<EditJournalPage> createState() => _EditJournalPageState();
}

class _EditJournalPageState extends State<EditJournalPage> {
  late final TextEditingController _titleController;
  late DateTime _date;
  late String? _goalId;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry.title);
    _date = widget.entry.date;
    _goalId = widget.entry.goalId;
    _titleController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
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
    widget.onSubmit(widget.entry.copyWith(
      title: _titleController.text.trim(),
      date: _date,
      goalId: () => _goalId,
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Entry')),
      body: Column(
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
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Entry title',
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
              ],
            ),
          ),
          const Spacer(),
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
                  child: const Text('Save Changes'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
