import 'package:flutter/material.dart';

import '../models/goal.dart';
import '../widgets/goal_form.dart';

class EditGoalPage extends StatelessWidget {
  const EditGoalPage({
    super.key,
    required this.goal,
    required this.onSubmit,
  });

  final Goal goal;
  final void Function(Goal) onSubmit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Goal')),
      body: GoalForm(
        initial: goal,
        submitLabel: 'Save Changes',
        onSubmit: onSubmit,
      ),
    );
  }
}
