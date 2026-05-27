import 'package:flutter/material.dart';

import '../models/goal.dart';
import 'section_label.dart';

class GoalForm extends StatefulWidget {
  const GoalForm({
    super.key,
    this.initial,
    required this.submitLabel,
    required this.onSubmit,
  });

  final Goal? initial;
  final String submitLabel;
  final void Function(Goal) onSubmit;

  @override
  State<GoalForm> createState() => _GoalFormState();
}

class _GoalFormState extends State<GoalForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late GoalCategory _category;
  late DateTime? _targetDate;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _titleController = TextEditingController(text: initial?.title ?? '');
    _descriptionController =
        TextEditingController(text: initial?.description ?? '');
    _category = initial?.category ?? GoalCategory.healthAndWellness;
    _targetDate = initial?.targetDate;
    _titleController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool get _canSubmit => _titleController.text.trim().isNotEmpty;

  Future<void> _pickTargetDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() => _targetDate = picked);
    }
  }

  void _handleSubmit() {
    final base = widget.initial ??
        Goal(
          id: Goal.newId(),
          title: '',
        );
    final goal = base.copyWith(
      title: _titleController.text.trim(),
      description: _descriptionController.text,
      category: _category,
      targetDate: _targetDate,
    );
    widget.onSubmit(goal);
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
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Goal name',
                  hintText: 'e.g. Run a marathon',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'What does achieving this goal look like?',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              const SectionLabel('Category'),
              const SizedBox(height: 8),
              DropdownButtonFormField<GoalCategory>(
                initialValue: _category,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                isExpanded: true,
                onChanged: (value) {
                  if (value != null) setState(() => _category = value);
                },
                items: GoalCategory.values
                    .map(
                      (c) => DropdownMenuItem(
                        value: c,
                        child: Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: c.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Flexible(child: Text(c.label)),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),
              const SectionLabel('Target Date'),
              const SizedBox(height: 8),
              Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  leading: const Icon(Icons.event_outlined),
                  title: const Text('Target date'),
                  subtitle: Text(
                    _targetDate != null
                        ? _formatDate(_targetDate!)
                        : 'No target date set',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _pickTargetDate,
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
