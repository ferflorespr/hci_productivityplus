import 'package:flutter/material.dart';

class TaskSlice {
  const TaskSlice(this.label, this.count);

  final String label;
  final int count;

  Color get color {
    switch (label) {
      case 'Habits':
        return Colors.green;
      case 'Goals':
        return Colors.blue;
      case 'Journal':
        return Colors.orange;
      default:
        return Colors.purple;
    }
  }
}