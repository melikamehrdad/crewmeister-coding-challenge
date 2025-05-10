import 'package:code_challenge/view/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
    testWidgets('AbsencesPage displays a list of absences', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: AbsencesPage(),
      ));

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Filters'), findsWidgets);
      expect(find.text('Reset'), findsWidgets);
    });
}
