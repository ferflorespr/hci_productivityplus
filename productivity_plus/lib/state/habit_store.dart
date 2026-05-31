import 'package:flutter/foundation.dart';

import '../models/habit.dart';

/// In-memory store of habits. Extends [ChangeNotifier] so any widget that
/// listens (via [ListenableBuilder]) rebuilds when the list changes.
///
/// Swap this out for a real persistence layer (sqflite, drift, Firebase, …)
/// later — callers only depend on the public API below.
class HabitStore extends ChangeNotifier {
  final List<Habit> _habits = [];

  List<Habit> get habits => List.unmodifiable(_habits);

  void add(Habit habit) {
    _habits.add(habit);
    notifyListeners();
  }

  void update(Habit habit) {
    final index = _habits.indexWhere((h) => h.id == habit.id);
    if (index == -1) return;
    _habits[index] = habit;
    notifyListeners();
  }
}
