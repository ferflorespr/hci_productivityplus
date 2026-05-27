import 'package:flutter/material.dart';

import '../state/goal_store.dart';

class GoalLinkDropdown extends StatelessWidget {
  const GoalLinkDropdown({
    super.key,
    required this.goalStore,
    required this.selectedGoalId,
    required this.onChanged,
  });

  final GoalStore goalStore;
  final String? selectedGoalId;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    final goals = goalStore.goals;
    final selected =
        goals.where((g) => g.id == selectedGoalId).firstOrNull;

    return DropdownButtonFormField<String>(
      initialValue: selected?.id,
      decoration: const InputDecoration(border: OutlineInputBorder()),
      isExpanded: true,
      hint: const Text('None'),
      onChanged: onChanged,
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('None'),
        ),
        ...goals.map(
          (g) => DropdownMenuItem<String>(
            value: g.id,
            child: Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: g.category.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    g.title,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
