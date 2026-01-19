import 'package:acumen_hymn_book/core/presentation/pages/hymn_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HymnEditScreen calls onSave when provided',
      (WidgetTester tester) async {
    bool onSaveCalled = false;
    String? savedContent;

    await tester.pumpWidget(MaterialApp(
      home: HymnEditScreen(
        assetPath: 'dummy/path',
        initialContent: 'Initial content',
        onSave: (content) async {
          onSaveCalled = true;
          savedContent = content;
        },
      ),
    ));

    // Verify initial content is loaded
    expect(find.text('Initial content'), findsOneWidget);

    // Enter new text
    await tester.enterText(find.byType(TextField), 'Updated content');

    // Tap save button
    await tester.tap(find.byIcon(Icons.save));
    await tester.pumpAndSettle();

    // Verify onSave was called with updated content
    expect(onSaveCalled, isTrue);
    expect(savedContent, 'Updated content');

    // Verify screen popped
    expect(find.byType(HymnEditScreen), findsNothing);
  });

  testWidgets('HymnEditScreen handles error in onSave',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: HymnEditScreen(
        assetPath: 'dummy/path',
        initialContent: 'Initial content',
        onSave: (content) async {
          throw Exception('Save failed');
        },
      ),
    ));

    // Tap save button
    await tester.tap(find.byIcon(Icons.save));
    await tester.pumpAndSettle();

    // Verify error snackbar
    expect(find.textContaining('Error saving hymn: Exception: Save failed'),
        findsOneWidget);
  });
}
