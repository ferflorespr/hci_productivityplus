import 'package:flutter/foundation.dart';

import '../models/journal_entry.dart';

/// In-memory store of journal entries. Returns entries in reverse-chronological
/// order so the newest entry appears at the top of the list.
class JournalStore extends ChangeNotifier {
  final List<JournalEntry> _entries = [];

  List<JournalEntry> get entries {
    final sorted = [..._entries]..sort((a, b) => b.date.compareTo(a.date));
    return List.unmodifiable(sorted);
  }

  void add(JournalEntry entry) {
    _entries.add(entry);
    notifyListeners();
  }

  void update(JournalEntry entry) {
    final i = _entries.indexWhere((e) => e.id == entry.id);
    if (i == -1) return;
    _entries[i] = entry;
    notifyListeners();
  }

  void delete(String id) {
    final removed = _entries.length;
    _entries.removeWhere((e) => e.id == id);
    if (_entries.length != removed) notifyListeners();
  }
}
