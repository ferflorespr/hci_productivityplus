import 'package:flutter/material.dart';

import 'page_body.dart';

class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PageBody(
        title: 'Journal',
        subtitle: 'Reflections and daily entries will appear here.',
      ),
    );
  }
}
