import 'package:flutter/material.dart';

enum GoalCategory {
  healthAndWellness(
    'Health & Physical Wellness',
    Color(0xFF4CAF50),
    Icons.favorite_rounded,
  ),
  financialAndWealth(
    'Financial & Wealth',
    Color(0xFFFFA726),
    Icons.savings_rounded,
  ),
  careerAndAcademic(
    'Career & Academic',
    Color(0xFF42A5F5),
    Icons.school_rounded,
  ),
  socialAndRelationships(
    'Social & Relationships',
    Color(0xFFEC407A),
    Icons.people_rounded,
  ),
  hobbiesAndCreativity(
    'Hobbies & Creativity',
    Color(0xFFAB47BC),
    Icons.palette_rounded,
  ),
  intellectualAndGrowth(
    'Intellectual & Personal Growth',
    Color(0xFF26A69A),
    Icons.psychology_rounded,
  );

  const GoalCategory(this.label, this.color, this.icon);

  final String label;
  final Color color;
  final IconData icon;
}

@immutable
class Goal {
  const Goal({
    required this.id,
    required this.title,
    this.description = '',
    this.category = GoalCategory.healthAndWellness,
    this.targetDate,
    this.completed = false,
    this.streakDays = 0,
    this.momentumOnHold = false,
    this.lapseDate,
    this.recoveryThresholdPct = 0.5,
  });

  final String id;
  final String title;
  final String description;
  final GoalCategory category;
  final DateTime? targetDate;
  final bool completed;
  /// Consecutive days this goal's linked habits were all completed.
  final int streakDays;
  /// True when a lapse was detected; streak is preserved until recovery succeeds or fails.
  final bool momentumOnHold;
  /// The date the lapse occurred.
  final DateTime? lapseDate;
  /// Fraction of linked habits that must be completed the day after a lapse to recover (default 0.5 = 50%).
  final double recoveryThresholdPct;

  static String newId() => DateTime.now().microsecondsSinceEpoch.toString();

  Goal copyWith({
    String? title,
    String? description,
    GoalCategory? category,
    DateTime? targetDate,
    bool? completed,
    int? streakDays,
    bool? momentumOnHold,
    DateTime? Function()? lapseDate,
    double? recoveryThresholdPct,
  }) {
    return Goal(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      targetDate: targetDate ?? this.targetDate,
      completed: completed ?? this.completed,
      streakDays: streakDays ?? this.streakDays,
      momentumOnHold: momentumOnHold ?? this.momentumOnHold,
      lapseDate: lapseDate != null ? lapseDate() : this.lapseDate,
      recoveryThresholdPct: recoveryThresholdPct ?? this.recoveryThresholdPct,
    );
  }
}
