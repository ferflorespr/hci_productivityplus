import 'package:flutter/material.dart';

import '../models/habit.dart';
import 'section_label.dart';

/// The form fields for creating or editing a habit. Lives inside a Scaffold
/// provided by the host page so the page controls the AppBar title and the
/// submit-button label.
class HabitForm extends StatefulWidget {
  const HabitForm({
    super.key,
    this.initial,
    required this.submitLabel,
    required this.onSubmit,
  });

  /// Existing habit to edit, or null when creating a new one.
  final Habit? initial;

  /// Label for the prominent bottom button (e.g. "Create Habit").
  final String submitLabel;

  /// Called with the final habit when the user taps the submit button.
  final void Function(Habit) onSubmit;

  @override
  State<HabitForm> createState() => _HabitFormState();
}

class _HabitFormState extends State<HabitForm> {
  late final TextEditingController _titleController;
  late bool _scheduleEnabled;
  late HabitFrequency _frequency;
  late DateTime? _startDate;
  late bool _remindersEnabled;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _titleController = TextEditingController(text: initial?.title ?? '');
    _scheduleEnabled = initial?.scheduleEnabled ?? false;
    _frequency = initial?.frequency ?? HabitFrequency.daily;
    _startDate = initial?.startDate;
    _remindersEnabled = initial?.remindersEnabled ?? false;

    // Keep submit-button enabled state in sync with the text field.
    _titleController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  bool get _canSubmit => _titleController.text.trim().isNotEmpty;

  Future<void> _pickStartDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  void _handleSubmit() {
    final habit = (widget.initial ?? Habit(id: Habit.newId(), title: '')).copyWith(
      title: _titleController.text.trim(),
      scheduleEnabled: _scheduleEnabled,
      frequency: _frequency,
      startDate: _scheduleEnabled ? (_startDate ?? DateTime.now()) : null,
      remindersEnabled: _remindersEnabled,
    );
    widget.onSubmit(habit);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            children: [
              const SectionLabel('Details'),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Habit name',
                  hintText: 'e.g. Read for 20 minutes',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              const SectionLabel('Schedule'),
              const SizedBox(height: 8),
              Card(
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Schedule'),
                      subtitle: const Text('Set how often this habit repeats'),
                      value: _scheduleEnabled,
                      onChanged: (v) => setState(() => _scheduleEnabled = v),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: _scheduleEnabled
                          ? Column(
                              children: [
                                const Divider(height: 1),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Frequency', style: theme.textTheme.labelLarge),
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        width: double.infinity,
                                        child: SegmentedButton<HabitFrequency>(
                                          segments: HabitFrequency.values
                                              .map((f) => ButtonSegment(
                                                    value: f,
                                                    label: Text(f.label),
                                                  ))
                                              .toList(),
                                          selected: {_frequency},
                                          onSelectionChanged: (s) =>
                                              setState(() => _frequency = s.first),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(height: 1),
                                ListTile(
                                  leading: const Icon(Icons.event_outlined),
                                  title: const Text('Starts on'),
                                  subtitle: Text(_formatDate(_startDate ?? DateTime.now())),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: _pickStartDate,
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const SectionLabel('Reminders'),
              const SizedBox(height: 8),
              Card(
                margin: EdgeInsets.zero,
                child: SwitchListTile(
                  title: const Text('Reminders'),
                  subtitle: const Text("We'll notify you when this habit is due"),
                  value: _remindersEnabled,
                  onChanged: (v) => setState(() => _remindersEnabled = v),
                ),
              ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
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

String _formatDate(DateTime d) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${months[d.month - 1]} ${d.day}, ${d.year}';
}
