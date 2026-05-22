import 'package:flutter/material.dart';

import 'page_body.dart';

class HabitsPage extends StatelessWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PageBody(
        title: 'Habits',
        subtitle: 'Daily routines, streaks, and check-ins will show here.',
      ),
    );
  }
}
