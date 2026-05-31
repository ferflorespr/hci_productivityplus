import 'package:flutter/material.dart';
import 'task_slice.dart';

class LegendRow extends StatelessWidget {
  const LegendRow({
    super.key,
    required this.slice,
  });

  final TaskSlice slice;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: slice.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(slice.label),
          ),
          Text(
            '${slice.count}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}