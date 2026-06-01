import 'package:flutter/foundation.dart';

/// How often a scheduled habit should recur.
enum HabitFrequency {
  daily('Daily'),
  weekly('Weekly'),
  monthly('Monthly');

  const HabitFrequency(this.label);

  final String label;
}

/// A single habit the user wants to build. Immutable — editing returns a new
/// instance via [copyWith] so list rebuilds are predictable.
@immutable
class Habit {
  const Habit({
    required this.id,
    required this.title,
    this.goalId,
    this.scheduleEnabled = false,
    this.frequency = HabitFrequency.daily,
    this.startDate,
    this.remindersEnabled = false,
    this.completedDates = const [],
  });

  final String id;
  final String title;
  final String? goalId;
  final bool scheduleEnabled;
  final HabitFrequency frequency;
  final DateTime? startDate;
  final bool remindersEnabled;
  /// ISO date strings ("YYYY-MM-DD") for days when this habit was completed.
  final List<String> completedDates;

  /// Generates a unique-enough id for in-memory use.
  static String newId() => DateTime.now().microsecondsSinceEpoch.toString();

  static String dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  bool isCompletedOn(DateTime date) => completedDates.contains(dateKey(date));

  Habit copyWith({
    String? title,
    String? Function()? goalId,
    bool? scheduleEnabled,
    HabitFrequency? frequency,
    DateTime? startDate,
    bool? remindersEnabled,
    List<String>? completedDates,
  }) {
    return Habit(
      id: id,
      title: title ?? this.title,
      goalId: goalId != null ? goalId() : this.goalId,
      scheduleEnabled: scheduleEnabled ?? this.scheduleEnabled,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      completedDates: completedDates ?? this.completedDates,
    );
  }
}
