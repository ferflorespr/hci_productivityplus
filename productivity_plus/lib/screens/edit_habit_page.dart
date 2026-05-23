import 'package:flutter/material.dart';

import '../models/habit.dart';
import '../widgets/habit_form.dart';

class EditHabitPage extends StatelessWidget {
  const EditHabitPage({
    super.key,
    required this.habit,
    required this.onSubmit,
  });

  final Habit habit;
  final void Function(Habit) onSubmit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Habit')),
      body: HabitForm(
        initial: habit,
        submitLabel: 'Save Changes',
        onSubmit: onSubmit,
      ),
    );
  }
}
