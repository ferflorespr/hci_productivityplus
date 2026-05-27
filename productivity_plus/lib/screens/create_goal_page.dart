import 'package:flutter/material.dart';

import '../models/goal.dart';
import '../widgets/goal_form.dart';

class CreateGoalPage extends StatelessWidget {
  const CreateGoalPage({super.key, required this.onSubmit});

  final void Function(Goal) onSubmit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Goal')),
      body: GoalForm(
        submitLabel: 'Create Goal',
        onSubmit: onSubmit,
      ),
    );
  }
}
