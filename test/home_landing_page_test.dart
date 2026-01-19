import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:acumen_hymn_book/core/presentation/pages/home_landing_page.dart';

void main() {
  testWidgets('HomeLandingPage shows default text and opens edit dialog',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const MaterialApp(
      home: HomeLandingPage(),
    ));

    // Check for default text
    expect(find.text("Welcome to Acumen Hymn Book"), findsOneWidget);

    // Open edit dialog
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    // Check dialog title and X icon
    expect(find.text("Edit Overlay Text"), findsOneWidget);
    expect(find.byIcon(Icons.close), findsOneWidget);

    // Check if dialog is not full screen (constrained width)
    final dialog = tester.widget<Dialog>(find.byType(Dialog));
    final dialogSizedBox = find
        .descendant(
          of: find.byWidget(dialog),
          matching: find.byType(SizedBox),
        )
        .first;

    final RenderBox renderBox = tester.renderObject(dialogSizedBox);
    expect(renderBox.size.width, equals(450));

    // Update text
    await tester.enterText(find.byType(TextField), "New Heading");
    await tester.tap(find.text("Update Heading"));
    await tester.pumpAndSettle();

    // Check if text persisted in UI
    expect(find.text("New Heading"), findsOneWidget);
  });

  testWidgets('Close icon in dialog works', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const MaterialApp(
      home: HomeLandingPage(),
    ));

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsNothing);
  });
}
