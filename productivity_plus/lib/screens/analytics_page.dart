import 'package:flutter/material.dart';

import 'page_body.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PageBody(
        title: 'Analytics',
        subtitle: 'Charts of your habit streaks and goal progress will appear here.',
      ),
    );
  }
}
