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

  void toggleCompletionOn(String habitId, DateTime date) {
    final index = _habits.indexWhere((h) => h.id == habitId);
    if (index == -1) return;
    final key = Habit.dateKey(date);
    final habit = _habits[index];
    final newDates = List<String>.from(habit.completedDates);
    if (newDates.contains(key)) {
      newDates.remove(key);
    } else {
      newDates.add(key);
    }
    _habits[index] = habit.copyWith(completedDates: newDates);
    notifyListeners();
  }

  bool isCompletedOn(String habitId, DateTime date) {
    final key = Habit.dateKey(date);
    final habit = _habits.where((h) => h.id == habitId).firstOrNull;
    return habit?.completedDates.contains(key) ?? false;
  }

  /// How many habits from [habitIds] were completed on [date].
  int countCompletedOn(Iterable<String> habitIds, DateTime date) {
    final key = Habit.dateKey(date);
    return _habits
        .where((h) => habitIds.contains(h.id) && h.completedDates.contains(key))
        .length;
  }
}
