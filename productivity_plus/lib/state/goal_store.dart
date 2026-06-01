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

  /// Puts the goal's momentum "on hold" without resetting the streak.
  void triggerLapse(String goalId, DateTime lapseDate) {
    final i = _goals.indexWhere((g) => g.id == goalId);
    if (i == -1) return;
    _goals[i] = _goals[i].copyWith(
      momentumOnHold: true,
      lapseDate: () => lapseDate,
    );
    notifyListeners();
  }

  /// Clears the on-hold state; streak is preserved (momentum continues).
  void recoverMomentum(String goalId) {
    final i = _goals.indexWhere((g) => g.id == goalId);
    if (i == -1) return;
    _goals[i] = _goals[i].copyWith(
      momentumOnHold: false,
      lapseDate: () => null,
    );
    notifyListeners();
  }

  /// Resets the streak to zero and clears the on-hold state.
  void resetStreak(String goalId) {
    final i = _goals.indexWhere((g) => g.id == goalId);
    if (i == -1) return;
    _goals[i] = _goals[i].copyWith(
      streakDays: 0,
      momentumOnHold: false,
      lapseDate: () => null,
    );
    notifyListeners();
  }

  void updateStreak(String goalId, int streakDays) {
    final i = _goals.indexWhere((g) => g.id == goalId);
    if (i == -1) return;
    _goals[i] = _goals[i].copyWith(streakDays: streakDays);
    notifyListeners();
  }
}
