import 'package:bloc_test/bloc_test.dart';
import 'package:code_challenge/presentation/bloc/absences_bloc.dart';
import 'package:code_challenge/presentation/view.dart';
import 'package:code_challenge/presentation/widgets/absence_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_test_data.dart';

class MockAbsencesBloc extends MockBloc<AbsencesEvent, AbsencesState>
    implements AbsencesBloc {}

void main() {
  late MockAbsencesBloc mockAbsencesBloc;
  setUp(() {
    mockAbsencesBloc = MockAbsencesBloc();
  });

  group('AbsencesPage Widget Tests', () {
    testWidgets('AbsencesPage displays AppBar and Filters', (tester) async {
      when(() => mockAbsencesBloc.state).thenReturn(AbsencesState(
        status: AbsencesStatus.success,
        absences: mockAbsences,
        totalAbsencesRequestCount: 0,
      ));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AbsencesBloc>(
            create: (_) => mockAbsencesBloc,
            child: const AbsencesPage(),
          ),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Absences Manager'), findsOneWidget);

      expect(find.byType(DropdownButton<String>), findsOneWidget);
      expect(find.byType(Icon), findsWidgets);
    });

    testWidgets('AbsenceCard displays absence details correctly',
        (tester) async {
      when(() => mockAbsencesBloc.state).thenReturn(
        AbsencesState(
            status: AbsencesStatus.success,
            absences: mockAbsences,
            totalAbsencesRequestCount: mockAbsences.length),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AbsencesBloc>(
            create: (_) => mockAbsencesBloc,
            child: const AbsencesPage(),
          ),
        ),
      );

      expect(
          find.byType(AbsenceCardWidget), findsNWidgets(mockAbsences.length));
      for (var absence in mockAbsences) {
        expect(find.text(absence.memberName), findsOneWidget);
        expect(find.text('Type: ${absence.type}'), findsWidgets);
        expect(find.text('Period: ${absence.startDate} - ${absence.endDate}'),
            findsOneWidget);
        if (absence.memberNote.isNotEmpty) {
          expect(
              find.text('Member note: ${absence.memberNote}'), findsOneWidget);
        }
        if (absence.admitterNote.isNotEmpty) {
          expect(find.text('Admitter note: ${absence.admitterNote}'),
              findsWidgets);
        }
      }
    });

    testWidgets('AbsencesPage shows empty state when no absences',
        (tester) async {
      when(() => mockAbsencesBloc.state).thenReturn(
        const AbsencesState(
          status: AbsencesStatus.success,
          absences: [],
          totalAbsencesRequestCount: 0,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AbsencesBloc>(
            create: (_) => mockAbsencesBloc,
            child: const AbsencesPage(),
          ),
        ),
      );

      expect(find.text('No absences found.'), findsOneWidget);
    });

    testWidgets('Filters apply correctly and reset works', (tester) async {
      when(() => mockAbsencesBloc.state).thenReturn(
        AbsencesState(
          status: AbsencesStatus.success,
          absences: mockAbsences,
          totalAbsencesRequestCount: mockAbsences.length,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AbsencesBloc>(
            create: (_) => mockAbsencesBloc,
            child: const AbsencesPage(),
          ),
        ),
      );

      expect(
          find.byType(AbsenceCardWidget), findsNWidgets(mockAbsences.length));

      await tester.tap(find.byType(DropdownButton<String>).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('vacation').last);
      await tester.pumpAndSettle();

      final filteredAbsences =
          mockAbsences.where((absence) => absence.type == 'vacation').toList();
      expect(find.byType(AbsenceCardWidget), findsWidgets);
      for (var absence in filteredAbsences) {
        expect(find.text(absence.memberName), findsOneWidget);
      }

      await tester.tap(find.text('Reset'));
      await tester.pumpAndSettle();

      expect(
          find.byType(AbsenceCardWidget), findsNWidgets(mockAbsences.length));
      for (var absence in mockAbsences) {
        expect(find.text(absence.memberName), findsOneWidget);
      }
    });
  });

  testWidgets('AbsencesPage shows loading indicator when state is loading',
      (tester) async {
    when(() => mockAbsencesBloc.state).thenReturn(
      const AbsencesState(status: AbsencesStatus.loading),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AbsencesBloc>(
          create: (_) => mockAbsencesBloc,
          child: const AbsencesPage(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('AbsencesPage shows error message when state is failed',
      (tester) async {
    when(() => mockAbsencesBloc.state).thenReturn(
      const AbsencesState(
        status: AbsencesStatus.failure,
        errorMessage: 'Failed to load absences',
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AbsencesBloc>(
          create: (_) => mockAbsencesBloc,
          child: const AbsencesPage(),
        ),
      ),
    );

    expect(find.text('Failed to load data.'), findsOneWidget);
  });
}
