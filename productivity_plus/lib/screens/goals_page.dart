import 'dart:math';

import 'package:flutter/material.dart';

import '../models/goal.dart';
import '../state/goal_store.dart';
import '../state/habit_store.dart';
import '../state/journal_store.dart';
import '../widgets/app_logo.dart';
import 'create_goal_page.dart';
import 'goal_category_page.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key, required this.store, this.habitStore, this.journalStore});

  final GoalStore store;
  final HabitStore? habitStore;
  final JournalStore? journalStore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AppLogo(height: 180),
            Text(
              'Goals',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListenableBuilder(
                listenable: store,
                builder: (context, _) {
                  final goals = store.goals;
                  if (goals.isEmpty) return const _EmptyState();
                  return _BubbleField(store: store, goals: goals, habitStore: habitStore, journalStore: journalStore);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        heroTag: 'add_goal_fab',
        onPressed: () => _openCreate(context),
        tooltip: 'Add goal',
        child: const Icon(Icons.add, size: 36),
      ),
    );
  }

  void _openCreate(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CreateGoalPage(onSubmit: store.add),
        fullscreenDialog: true,
      ),
    );
  }
}



class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'No goals yet',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to create your first goal.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryBubble {
  _CategoryBubble({
    required this.category,
    required this.count,
    required this.offset,
    required this.radius,
  });

  final GoalCategory category;
  final int count;
  Offset offset;
  final double radius;
}

class _BubbleField extends StatefulWidget {
  const _BubbleField({required this.store, required this.goals, this.habitStore, this.journalStore});

  final GoalStore store;
  final List<Goal> goals;
  final HabitStore? habitStore;
  final JournalStore? journalStore;

  @override
  State<_BubbleField> createState() => _BubbleFieldState();
}

class _BubbleFieldState extends State<_BubbleField> {
  List<_CategoryBubble> _bubbles = [];
  int? _dragIndex;
  bool _positioned = false;

  Map<GoalCategory, int> _countByCategory(List<Goal> goals) {
    // Initialize every category that has at least one goal with 1
    final map = <GoalCategory, int>{};
    for (final g in goals) {
      map[g.category] = 1;
    }
    // Grow the count by the number of habits linked to goals in each category
    if (widget.habitStore != null) {
      for (final h in widget.habitStore!.habits) {
        if (h.goalId == null) continue;
        final goal = goals.where((g) => g.id == h.goalId).firstOrNull;
        if (goal == null) continue;
        map[goal.category] = (map[goal.category] ?? 1) + 1;
      }
    }
    return map;
  }

  void _buildBubbles(Size size) {
    final counts = _countByCategory(widget.goals);
    if (counts.isEmpty) return;

    final maxCount = counts.values.reduce(max);
    const minRadius = 38.0;
    final maxRadius = min(size.width, size.height) * 0.22;
    final center = Offset(size.width / 2, size.height / 2);

    final oldPositions = <GoalCategory, Offset>{};
    for (final b in _bubbles) {
      oldPositions[b.category] = b.offset;
    }

    final entries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final newBubbles = <_CategoryBubble>[];
    final angleStep = 2 * pi / entries.length;

    for (var i = 0; i < entries.length; i++) {
      final e = entries[i];
      final fraction = e.value / maxCount;
      final radius = minRadius + fraction * (maxRadius - minRadius);

      Offset offset;
      if (oldPositions.containsKey(e.key)) {
        offset = oldPositions[e.key]!;
      } else if (entries.length == 1) {
        offset = center;
      } else {
        final spreadRadius = (size.width / 2) * 0.45;
        final angle = -pi / 2 + angleStep * i;
        offset = Offset(
          center.dx + spreadRadius * cos(angle),
          center.dy + spreadRadius * sin(angle),
        );
      }

      newBubbles.add(_CategoryBubble(
        category: e.key,
        count: e.value,
        offset: offset,
        radius: radius,
      ));
    }

    _bubbles = newBubbles;
    _positioned = true;
  }

  void _openCategory(BuildContext context, GoalCategory category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GoalCategoryPage(
          category: category,
          store: widget.store,
          habitStore: widget.habitStore,
          journalStore: widget.journalStore,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);

        if (!_positioned || _dragIndex == null) {
          _buildBubbles(size);
        }

        return Stack(
          clipBehavior: Clip.none,
          children: [
            for (var i = 0; i < _bubbles.length; i++)
              _PositionedBubble(
                bubble: _bubbles[i],
                isDragging: _dragIndex == i,
                onDragStart: () => setState(() => _dragIndex = i),
                onDragUpdate: (delta) {
                  setState(() {
                    final b = _bubbles[i];
                    var newOffset = b.offset + delta;
                    newOffset = Offset(
                      newOffset.dx.clamp(b.radius, size.width - b.radius),
                      newOffset.dy.clamp(b.radius, size.height - b.radius),
                    );
                    b.offset = newOffset;
                  });
                },
                onDragEnd: () => setState(() => _dragIndex = null),
                onTap: () => _openCategory(context, _bubbles[i].category),
              ),
          ],
        );
      },
    );
  }
}

class _PositionedBubble extends StatelessWidget {
  const _PositionedBubble({
    required this.bubble,
    required this.isDragging,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onTap,
  });

  final _CategoryBubble bubble;
  final bool isDragging;
  final VoidCallback onDragStart;
  final void Function(Offset delta) onDragUpdate;
  final VoidCallback onDragEnd;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final diameter = bubble.radius * 2;

    return Positioned(
      left: bubble.offset.dx - bubble.radius,
      top: bubble.offset.dy - bubble.radius,
      child: GestureDetector(
        onTap: onTap,
        onLongPressStart: (_) => onDragStart(),
        onLongPressMoveUpdate: (details) =>
            onDragUpdate(details.offsetFromOrigin -
                (details.localOffsetFromOrigin)),
        onLongPressEnd: (_) => onDragEnd(),
        onPanStart: (_) => onDragStart(),
        onPanUpdate: (details) => onDragUpdate(details.delta),
        onPanEnd: (_) => onDragEnd(),
        child: AnimatedScale(
          scale: isDragging ? 1.1 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: diameter,
            height: diameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bubble.category.color.withAlpha(isDragging ? 60 : 38),
              border: Border.all(
                color: bubble.category.color.withAlpha(isDragging ? 200 : 140),
                width: 2.5,
              ),
              boxShadow: isDragging
                  ? [
                      BoxShadow(
                        color: bubble.category.color.withAlpha(60),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  bubble.category.icon,
                  color: bubble.category.color,
                  size: (bubble.radius * 0.4).clamp(16.0, 32.0),
                ),
                const SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    bubble.category.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: bubble.category.color,
                      fontWeight: FontWeight.w700,
                      fontSize: (bubble.radius * 0.17).clamp(8.0, 12.0),
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  '${bubble.count}',
                  style: TextStyle(
                    color: bubble.category.color,
                    fontWeight: FontWeight.w800,
                    fontSize: (bubble.radius * 0.28).clamp(12.0, 24.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
