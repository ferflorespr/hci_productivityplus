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
    this.scheduleEnabled = false,
    this.frequency = HabitFrequency.daily,
    this.startDate,
    this.remindersEnabled = false,
  });

  final String id;
  final String title;
  final bool scheduleEnabled;
  final HabitFrequency frequency;
  final DateTime? startDate;
  final bool remindersEnabled;

  /// Generates a unique-enough id for in-memory use.
  static String newId() => DateTime.now().microsecondsSinceEpoch.toString();

  Habit copyWith({
    String? title,
    bool? scheduleEnabled,
    HabitFrequency? frequency,
    DateTime? startDate,
    bool? remindersEnabled,
  }) {
    return Habit(
      id: id,
      title: title ?? this.title,
      scheduleEnabled: scheduleEnabled ?? this.scheduleEnabled,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
    );
  }
}
