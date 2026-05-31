import 'package:flutter/foundation.dart';

/// A single journal entry. Immutable — edits return a new instance via
/// [copyWith].
@immutable
class JournalEntry {
  const JournalEntry({
    required this.id,
    required this.title,
    required this.date,
    required this.content,
    this.goalId,
  });

  final String id;
  final String title;
  final DateTime date;
  final String content;
  final String? goalId;

  static String newId() => DateTime.now().microsecondsSinceEpoch.toString();

  JournalEntry copyWith({
    String? title,
    DateTime? date,
    String? content,
    String? Function()? goalId,
  }) {
    return JournalEntry(
      id: id,
      title: title ?? this.title,
      date: date ?? this.date,
      content: content ?? this.content,
      goalId: goalId != null ? goalId() : this.goalId,
    );
  }
}
