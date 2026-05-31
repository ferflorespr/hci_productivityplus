import 'package:flutter/foundation.dart';

import '../models/goal.dart';

class GoalStore extends ChangeNotifier {
  final List<Goal> _goals = [];

  List<Goal> get goals => List.unmodifiable(_goals);

  void add(Goal goal) {
    _goals.add(goal);
    notifyListeners();
  }

  void update(Goal goal) {
    final i = _goals.indexWhere((g) => g.id == goal.id);
    if (i == -1) return;
    _goals[i] = goal;
    notifyListeners();
  }

  void delete(String id) {
    final removed = _goals.length;
    _goals.removeWhere((g) => g.id == id);
    if (_goals.length != removed) notifyListeners();
  }
}
