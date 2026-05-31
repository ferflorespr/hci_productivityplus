import 'package:flutter/material.dart';

import '../models/habit.dart';
import '../state/goal_store.dart';
import '../widgets/habit_form.dart';

class CreateHabitPage extends StatelessWidget {
  const CreateHabitPage({
    super.key,
    required this.onSubmit,
    this.goalStore,
  });

  final void Function(Habit) onSubmit;
  final GoalStore? goalStore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Habit')),
      body: HabitForm(
        submitLabel: 'Create Habit',
        onSubmit: onSubmit,
        goalStore: goalStore,
      ),
    );
  }
}
