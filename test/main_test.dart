import 'package:acumen_hymn_book/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:acumen_hymn_book/main.dart';
import 'package:acumen_hymn_book/core/constants/app_colors.dart';

void main() {
  testWidgets('MyApp shows MainScreen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const MyApp());

    expect(find.byType(MainScreen), findsOneWidget);
  });

  testWidgets(
      'Tapping on a side panel item does not show a CircularProgressIndicator',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byWidgetPredicate(
      (Widget widget) =>
          widget is Text &&
          widget.data == 'SDA Hymnal' &&
          widget.style?.color != AppColors.mainColor,
    ));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
