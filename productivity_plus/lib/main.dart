import 'package:flutter/material.dart';

import 'screens/main_scaffold.dart';

void main() {
  runApp(const ProductivityPlusApp());
}

class ProductivityPlusApp extends StatelessWidget {
  const ProductivityPlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Seed color drives the whole Material 3 palette (primary, surface,
    // containers, etc.). Change this one value and the app re-themes.
    const seed = Color(0xFF5B6BFF);

    return MaterialApp(
      title: 'Productivity+',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
      ),
      home: const MainScaffold(),
    );
  }
}
