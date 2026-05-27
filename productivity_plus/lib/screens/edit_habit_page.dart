import 'package:flutter/material.dart';

import '../models/habit.dart';
import '../state/goal_store.dart';
import '../widgets/habit_form.dart';

class EditHabitPage extends StatelessWidget {
  const EditHabitPage({
    super.key,
    required this.habit,
    required this.onSubmit,
    this.goalStore,
  });

  final Habit habit;
  final void Function(Habit) onSubmit;
  final GoalStore? goalStore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Habit')),
      body: HabitForm(
        initial: habit,
        submitLabel: 'Save Changes',
        onSubmit: onSubmit,
        goalStore: goalStore,
      ),
    );
  }
}
