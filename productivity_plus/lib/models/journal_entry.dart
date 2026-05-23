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
  });

  final String id;
  final String title;
  final DateTime date;
  final String content;

  static String newId() => DateTime.now().microsecondsSinceEpoch.toString();

  JournalEntry copyWith({
    String? title,
    DateTime? date,
    String? content,
  }) {
    return JournalEntry(
      id: id,
      title: title ?? this.title,
      date: date ?? this.date,
      content: content ?? this.content,
    );
  }
}
