import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:productivity_plus/main.dart';

void main() {
  testWidgets('App boots with bottom nav and starts on Habits', (tester) async {
    await tester.pumpWidget(const ProductivityPlusApp());

    expect(find.text('Habits'), findsWidgets);
    expect(find.text('Journal'), findsWidgets);
    expect(find.text('Goals'), findsOneWidget);
    expect(find.text('Analytics'), findsOneWidget);

    await tester.tap(find.text('Journal').last);
    await tester.pumpAndSettle();
    expect(find.text('Journal'), findsWidgets);
  });

  testWidgets('Habits FAB opens the create-habit screen', (tester) async {
    await tester.pumpWidget(const ProductivityPlusApp());

    await tester.tap(find.byIcon(Icons.add).hitTestable());
    await tester.pumpAndSettle();

    expect(find.text('New Habit'), findsOneWidget);
    expect(find.text('Create Habit'), findsOneWidget);
  });

  testWidgets('Creating a habit adds it to the list', (tester) async {
    await tester.pumpWidget(const ProductivityPlusApp());

    expect(find.text('No habits yet'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add).hitTestable());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Read for 20 minutes');
    await tester.pump();
    await tester.tap(find.text('Create Habit'));
    await tester.pumpAndSettle();

    expect(find.text('Read for 20 minutes'), findsOneWidget);
  });

  testWidgets('Creating a journal entry adds it to the list', (tester) async {
    await tester.pumpWidget(const ProductivityPlusApp());

    await tester.tap(find.text('Journal').last);
    await tester.pumpAndSettle();

    expect(find.text('No entries yet'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add).hitTestable());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'My first entry');
    await tester.pump();
    await tester.tap(find.text('Save Entry'));
    await tester.pumpAndSettle();

    expect(find.text('My first entry'), findsOneWidget);
  });

  testWidgets('Tapping an entry opens the iOS-Notes-style viewer', (tester) async {
    await tester.pumpWidget(const ProductivityPlusApp());

    await tester.tap(find.text('Journal').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add).hitTestable());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Quiet day');
    await tester.pump();
    await tester.tap(find.text('Save Entry'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ListTile, 'Quiet day'));
    await tester.pumpAndSettle();

    expect(find.text('Quiet day'), findsOneWidget);
    expect(find.byTooltip('Edit title and date'), findsOneWidget);
  });
}
