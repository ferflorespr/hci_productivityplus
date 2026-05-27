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
