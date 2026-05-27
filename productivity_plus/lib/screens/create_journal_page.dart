import 'package:flutter/material.dart';

import '../models/journal_entry.dart';
import '../state/goal_store.dart';
import '../widgets/journal_form.dart';

class CreateJournalPage extends StatelessWidget {
  const CreateJournalPage({
    super.key,
    required this.onSubmit,
    this.goalStore,
  });

  final void Function(JournalEntry) onSubmit;
  final GoalStore? goalStore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Entry')),
      body: JournalForm(
        submitLabel: 'Save Entry',
        onSubmit: onSubmit,
        goalStore: goalStore,
      ),
    );
  }
}
