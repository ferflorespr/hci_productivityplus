import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:productivity_plus/main.dart';

void main() {
  testWidgets('App boots with bottom nav and starts on Habits', (tester) async {
    await tester.pumpWidget(const ProductivityPlusApp());

    // All four tabs render their labels in the NavigationBar.
    expect(find.text('Habits'), findsWidgets);
    expect(find.text('Journal'), findsOneWidget);
    expect(find.text('Goals'), findsOneWidget);
    expect(find.text('Analytics'), findsOneWidget);

    // Tapping a tab switches the AppBar title.
    await tester.tap(find.text('Journal'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'Journal'), findsOneWidget);
  });
}
