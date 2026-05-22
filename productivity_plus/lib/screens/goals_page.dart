import 'package:flutter/material.dart';

import 'page_body.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PageBody(
        title: 'Goals',
        subtitle: 'Longer-term goals and milestones will appear here.',
      ),
    );
  }
}
