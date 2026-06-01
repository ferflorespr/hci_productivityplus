import '../models/goal.dart';
import '../models/habit.dart';
import '../models/journal_entry.dart';
import 'goal_store.dart';
import 'habit_store.dart';
import 'journal_store.dart';

/// Populates the stores with sample data for usability testing.
///
/// To enable:  uncomment the `seedStores(...)` call in main_scaffold.dart.
/// To disable: comment it back out — the app starts empty.
void seedStores({
  required GoalStore goalStore,
  required HabitStore habitStore,
  required JournalStore journalStore,
}) {
  // ── Goals (5 goals, 3 categories) ──────────────────────────────────────

  const goalRunMarathon = Goal(
    id: 'goal_1',
    title: 'Run a marathon',
    description: 'Train consistently and complete a full 26.2-mile marathon by end of year.',
    category: GoalCategory.healthAndWellness,
    targetDate: null,
  );

  const goalEatHealthier = Goal(
    id: 'goal_2',
    title: 'Eat healthier meals',
    description: 'Cook at home at least 5 days a week with balanced nutrition.',
    category: GoalCategory.healthAndWellness,
    targetDate: null,
  );

  const goalPromotion = Goal(
    id: 'goal_3',
    title: 'Get promoted to senior role',
    description: 'Take on leadership projects and complete the management training program.',
    category: GoalCategory.careerAndAcademic,
    targetDate: null,
  );

  const goalCertification = Goal(
    id: 'goal_4',
    title: 'Earn cloud certification',
    description: 'Study for and pass the AWS Solutions Architect exam.',
    category: GoalCategory.careerAndAcademic,
    targetDate: null,
    streakDays: 5,
  );

  const goalLearnGuitar = Goal(
    id: 'goal_5',
    title: 'Learn to play guitar',
    description: 'Practice regularly and be able to play 10 songs by summer.',
    category: GoalCategory.hobbiesAndCreativity,
    targetDate: null,
  );

  // Daniela's goal — 14-day streak currently on hold after a Tuesday lapse
  final goalNoPhoneMorning = Goal(
    id: 'goal_6',
    title: 'No-Phone Morning',
    description:
        'Start each morning without phone distraction. Build a focused morning routine through journaling, sketching, and other mindful habits.',
    category: GoalCategory.intellectualAndGrowth,
    streakDays: 14,
    momentumOnHold: true,
    lapseDate: DateTime.now().subtract(const Duration(days: 1)),
    recoveryThresholdPct: 0.5,
  );

  for (final g in [goalRunMarathon, goalEatHealthier, goalPromotion, goalCertification, goalLearnGuitar, goalNoPhoneMorning]) {
    goalStore.add(g);
  }

  // ── Habits (5 habits, linked to goals) ─────────────────────────────────

  final todayKey = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';

  final habits = [
    const Habit(
      id: 'habit_1',
      title: 'Morning 5K run',
      goalId: 'goal_1',
      scheduleEnabled: true,
      frequency: HabitFrequency.daily,
      remindersEnabled: true,
    ),
    const Habit(
      id: 'habit_2',
      title: 'Meal prep on Sundays',
      goalId: 'goal_2',
      scheduleEnabled: true,
      frequency: HabitFrequency.weekly,
    ),
    const Habit(
      id: 'habit_3',
      title: 'Read leadership articles',
      goalId: 'goal_3',
      scheduleEnabled: true,
      frequency: HabitFrequency.daily,
    ),
    const Habit(
      id: 'habit_4',
      title: 'AWS practice questions',
      goalId: 'goal_4',
      scheduleEnabled: true,
      frequency: HabitFrequency.daily,
      remindersEnabled: true,
    ),
    const Habit(
      id: 'habit_5',
      title: 'Guitar practice 30 min',
      goalId: 'goal_5',
      scheduleEnabled: true,
      frequency: HabitFrequency.daily,
    ),
    // Daniela's morning habits — 6 total, recovery requires completing 3
    Habit(
      id: 'habit_6',
      title: 'Morning journaling',
      goalId: 'goal_6',
      scheduleEnabled: true,
      frequency: HabitFrequency.daily,
      completedDates: [todayKey],
    ),
    Habit(
      id: 'habit_7',
      title: 'Sketching practice',
      goalId: 'goal_6',
      scheduleEnabled: true,
      frequency: HabitFrequency.daily,
      completedDates: [todayKey],
    ),
    const Habit(
      id: 'habit_8',
      title: 'Morning meditation',
      goalId: 'goal_6',
      scheduleEnabled: true,
      frequency: HabitFrequency.daily,
    ),
    const Habit(
      id: 'habit_9',
      title: 'Light stretching',
      goalId: 'goal_6',
      scheduleEnabled: true,
      frequency: HabitFrequency.daily,
    ),
    const Habit(
      id: 'habit_10',
      title: 'Read 10 pages',
      goalId: 'goal_6',
      scheduleEnabled: true,
      frequency: HabitFrequency.daily,
    ),
    const Habit(
      id: 'habit_11',
      title: 'Healthy breakfast',
      goalId: 'goal_6',
      scheduleEnabled: true,
      frequency: HabitFrequency.daily,
    ),
  ];

  for (final h in habits) {
    habitStore.add(h);
  }

  // ── Journal entries (5 entries, linked to goals) ───────────────────────

  final now = DateTime.now();

  final entries = [
    JournalEntry(
      id: 'entry_1',
      title: 'First 5K without stopping',
      date: now.subtract(const Duration(days: 1)),
      content: 'Managed to run the full 5K today without walking breaks. Pace was slow but consistent. Feeling great about the progress.',
      goalId: 'goal_1',
    ),
    JournalEntry(
      id: 'entry_2',
      title: 'New recipe: chicken stir-fry',
      date: now.subtract(const Duration(days: 3)),
      content: 'Tried a new chicken stir-fry recipe. Quick to make and tastes good — adding it to the weekly rotation.',
      goalId: 'goal_2',
    ),
    JournalEntry(
      id: 'entry_3',
      title: 'Led the sprint retro today',
      date: now.subtract(const Duration(days: 5)),
      content: 'Volunteered to facilitate the sprint retrospective. Got positive feedback from the team on how I structured the discussion.',
      goalId: 'goal_3',
    ),
    JournalEntry(
      id: 'entry_4',
      title: 'Finished the S3 module',
      date: now.subtract(const Duration(days: 7)),
      content: 'Completed the S3 deep-dive module. Storage classes and lifecycle policies make a lot more sense now.',
      goalId: 'goal_4',
    ),
    JournalEntry(
      id: 'entry_5',
      title: 'Learned my first full song',
      date: now.subtract(const Duration(days: 2)),
      content: 'Finally got through "Wonderwall" start to finish. Chord transitions are still rough but it feels like real progress.',
      goalId: 'goal_5',
    ),
  ];

  for (final e in entries) {
    journalStore.add(e);
  }
}
