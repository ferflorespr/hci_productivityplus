# Productivity+

Productivity+ is a Human-Computer Interaction course project focused on designing a productivity-support experience through user-centered research, interviews, personas, and iterative proposal work.

The project is currently in its research and concept-development stage. This repository documents the team process, design rationale, and supporting materials for the Productivity+ proposal.

## Project Overview

Productivity+ explores how a digital tool can support users in organizing work, understanding their priorities, and improving day-to-day productivity. The project follows an HCI workflow that emphasizes understanding target users before defining features or implementation details.

The work completed so far includes:

- Initial project concept
- Target user definition
- User interview questions
- Two user interviews with notes
- User research results
- Personas
- Task analysis for the final proposal
- Proposal introduction and related work
- Presentation materials

## Team

The project was completed by a five-person team:

| Team member |
| --- |
| Adrian Ortiz |
| Kevin Ibarra |
| Alejandro Lopez |
| Alexis Traverso |
| Fernando Flores |

## Research Process

The team divided the work across the main stages of the HCI design process:

1. **Concept definition**: The team developed the initial idea for Productivity+ and clarified the problem space.
2. **User research planning**: Interview questions were written to guide conversations with potential users.
3. **User interviews**: Team members conducted two interviews, asked follow-up questions, and recorded notes.
4. **Research synthesis**: Interview findings were organized into user research results, target users, and personas.
5. **Proposal development**: The team prepared the proposal introduction, related work, tasks, and presentation.

## Collaboration

The team distributed work evenly, with each member contributing approximately 20% of the overall effort. Responsibilities rotated across deliverables so that different members led different parts of the project while others reviewed, expanded, or refined the work.

The group emphasized trust, short meetings, clear task ownership, and enough review time before each submission.

## Repository Status

This repository currently contains documentation for the Productivity+ project. Implementation files, design assets, research notes, or proposal documents can be added as the project develops.

 Future additions:

- `/docs` for proposal drafts and research summaries
- `/research` for interview protocols, notes, and synthesis
- `/personas` for persona artifacts
- `/presentation` for slides and supporting materials


## Usability Testing

The app supports two testing configurations controlled by a single line in
`productivity_plus/lib/screens/main_scaffold.dart`.

### Test 1 — Empty Start (no pre-existing data)

The app launches with no goals, habits, or journal entries. This tests the
first-time user experience and creation flows.

In `main_scaffold.dart`, **comment out** the seed line 34 inside `initState`:

```dart
@override
void initState() {
  super.initState();
  // seedStores(goalStore: _goalStore, habitStore: _habitStore, journalStore: _journalStore);
}
```

### Test 2 — Pre-populated Data

The app launches with sample data already loaded so testers can immediately
explore browsing, editing, and linking features. The seed data includes:

- **5 goals** across 3 categories (Health & Physical Wellness, Career & Academic, Hobbies & Creativity)
- **5 habits** each linked to a goal
- **5 journal entries** each linked to a goal

In `main_scaffold.dart`, **uncomment** the seed line 34 inside `initState`:

```dart
@override
void initState() {
  super.initState();
  seedStores(goalStore: _goalStore, habitStore: _habitStore, journalStore: _journalStore);
}
```

### Running the app

```bash
cd productivity_plus
flutter run
```

## License

This project is licensed under the GNU General Public License v3.0. See [LICENSE](LICENSE) for details.
