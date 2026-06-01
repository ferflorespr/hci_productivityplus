import 'package:flutter/material.dart';

class TaskSlice {
  const TaskSlice(this.label, this.count, {Color? color}) : _color = color;

  final String label;
  final int count;
  final Color? _color;

  Color get color {
    if (_color != null) return _color;
    switch (label) {
      case 'Habits':
        return const Color(0xFF4CAF50);
      case 'Goals':
        return const Color(0xFF42A5F5);
      case 'Journal':
        return const Color(0xFFFFA726);
      default:
        return const Color(0xFFAB47BC);
    }
  }
}
