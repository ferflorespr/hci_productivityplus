import 'package:flutter/material.dart';

import '../state/habit_store.dart';
import 'analytics_page.dart';
import 'goals_page.dart';
import 'habits_page.dart';
import 'journal_page.dart';

/// The app's root shell: holds the bottom navigation bar and swaps the page
/// shown above it. Each tab is a separate widget kept alive by [IndexedStack],
/// so scroll position and form state survive when the user switches tabs.
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  // Single shared instance of the habit store, owned by the root scaffold.
  // Passed into pages that need to read or mutate it.
  final HabitStore _habitStore = HabitStore();

  int _currentIndex = 0;

  late final List<Widget> _pages = [
    HabitsPage(store: _habitStore),
    const JournalPage(),
    const GoalsPage(),
    const AnalyticsPage(),
  ];

  @override
  void dispose() {
    _habitStore.dispose();
    super.dispose();
  }

  static const _destinations = <NavigationDestination>[
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home_rounded),
      label: 'Habits',
    ),
    NavigationDestination(
      icon: Icon(Icons.menu_book_outlined),
      selectedIcon: Icon(Icons.menu_book_rounded),
      label: 'Journal',
    ),
    NavigationDestination(
      icon: Icon(Icons.flag_outlined),
      selectedIcon: Icon(Icons.flag_rounded),
      label: 'Goals',
    ),
    NavigationDestination(
      icon: Icon(Icons.bar_chart_outlined),
      selectedIcon: Icon(Icons.bar_chart_rounded),
      label: 'Analytics',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: _destinations,
      ),
    );
  }
}
