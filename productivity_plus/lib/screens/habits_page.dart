import 'package:flutter/material.dart';

import 'create_habit_page.dart';
import 'page_body.dart';

class HabitsPage extends StatelessWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const PageBody(
        title: 'Habits',
        subtitle: 'Daily routines, streaks, and check-ins will show here.',
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () => _openCreateHabit(context),
        tooltip: 'Add habit',
        child: const Icon(Icons.add, size: 36),
      ),
    );
  }

  void _openCreateHabit(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const CreateHabitPage(),
        fullscreenDialog: true,
      ),
    );
  }
}
