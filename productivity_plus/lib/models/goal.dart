import 'dart:ui';

import 'package:flutter/foundation.dart';

enum GoalCategory {
  healthAndWellness(
    'Health & Physical Wellness',
    Color(0xFF4CAF50),
  ),
  financialAndWealth(
    'Financial & Wealth',
    Color(0xFFFFA726),
  ),
  careerAndAcademic(
    'Career & Academic',
    Color(0xFF42A5F5),
  ),
  socialAndRelationships(
    'Social & Relationships',
    Color(0xFFEC407A),
  ),
  hobbiesAndCreativity(
    'Hobbies & Creativity',
    Color(0xFFAB47BC),
  ),
  intellectualAndGrowth(
    'Intellectual & Personal Growth',
    Color(0xFF26A69A),
  );

  const GoalCategory(this.label, this.color);

  final String label;
  final Color color;
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
  });

  final String id;
  final String title;
  final String description;
  final GoalCategory category;
  final DateTime? targetDate;
  final bool completed;

  static String newId() => DateTime.now().microsecondsSinceEpoch.toString();

  Goal copyWith({
    String? title,
    String? description,
    GoalCategory? category,
    DateTime? targetDate,
    bool? completed,
  }) {
    return Goal(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      targetDate: targetDate ?? this.targetDate,
      completed: completed ?? this.completed,
    );
  }
}
