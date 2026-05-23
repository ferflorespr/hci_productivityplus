import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:productivity_plus/main.dart';

void main() {
  testWidgets('App boots with bottom nav and starts on Habits', (tester) async {
    await tester.pumpWidget(const ProductivityPlusApp());

    expect(find.text('Habits'), findsWidgets);
    expect(find.text('Journal'), findsOneWidget);
    expect(find.text('Goals'), findsOneWidget);
    expect(find.text('Analytics'), findsOneWidget);

    await tester.tap(find.text('Journal'));
    await tester.pumpAndSettle();
    expect(find.text('Journal'), findsNWidgets(2));
  });

  testWidgets('Habits FAB opens the create-habit screen', (tester) async {
    await tester.pumpWidget(const ProductivityPlusApp());

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('New Habit'), findsOneWidget);
    expect(find.text('Create Habit'), findsOneWidget);
  });

  testWidgets('Creating a habit adds it to the list', (tester) async {
    await tester.pumpWidget(const ProductivityPlusApp());

    expect(find.text('No habits yet'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Read for 20 minutes');
    await tester.tap(find.text('Create Habit'));
    await tester.pumpAndSettle();

    expect(find.text('No habits yet'), findsNothing);
    expect(find.text('Read for 20 minutes'), findsOneWidget);
  });
}
