import 'package:bloc_test/bloc_test.dart';
import 'package:code_challenge/bloc/absences_bloc.dart';
import 'package:code_challenge/domain/domain.dart';
import 'package:code_challenge/view/view.dart';
import 'package:code_challenge/view/widgets/absence_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAbsencesBloc extends MockBloc<AbsencesEvent, AbsencesState>
    implements AbsencesBloc {}

void main() {
  late MockAbsencesBloc mockAbsencesBloc;

  List<Absence> mockAbsences = [
    Absence(
      userId: 1,
      type: 'vacation',
      startDate: '2024-05-01',
      endDate: '2024-05-05',
      memberNote: 'Enjoying the vacation',
      admitterNote: 'Approved',
      status: 'Confirmed',
      createdAt: '2024-05-01',
      crewId: 1,
      id: 1,
      memberName: 'John Doe',
      memberImage: 'http://example.com/image1.jpg',
    ),
    Absence(
      userId: 2,
      type: 'sickness',
      startDate: '2024-05-06',
      endDate: '2024-05-08',
      memberNote: 'Feeling unwell',
      admitterNote: 'Pending approval',
      status: 'Requested',
      createdAt: '2024-05-06',
      crewId: 2,
      id: 2,
      memberName: 'Jane Smith',
      memberImage: 'http://example.com/image2.jpg',
    ),
    Absence(
      userId: 3,
      type: 'vacation',
      startDate: '2024-05-10',
      endDate: '2024-05-12',
      memberNote: 'Family trip',
      admitterNote: 'Approved',
      status: 'Confirmed',
      createdAt: '2024-05-10',
      crewId: 3,
      id: 3,
      memberName: 'Alice Johnson',
      memberImage: 'http://example.com/image3.jpg',
    ),
  ];

  setUpAll(() {
    registerFallbackValue(AbsencesRequest(pageNumber: 1, pageSize: 10));
  });

  setUp(() {
    mockAbsencesBloc = MockAbsencesBloc();
  });

  group('AbsencesPage Widget Tests', () {
    testWidgets('AbsencesPage displays AppBar and Filters', (tester) async {
      when(() => mockAbsencesBloc.state).thenReturn(const AbsencesState(
          status: AbsencesStatus.success, absences: [], totalAbsencesCount: 0));

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
            totalAbsencesCount: mockAbsences.length),
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

    testWidgets('Filters apply correctly and reset works', (tester) async {
      when(() => mockAbsencesBloc.state).thenReturn(
        AbsencesState(
            status: AbsencesStatus.success,
            absences: mockAbsences,
            totalAbsencesCount: mockAbsences.length),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AbsencesBloc>(
            create: (_) => mockAbsencesBloc,
            child: const AbsencesPage(),
          ),
        ),
      );

      expect(find.text('All'), findsOneWidget);
      expect(find.text('Date'), findsOneWidget);

      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('vacation'));
      await tester.pumpAndSettle();

      expect(find.text('vacation'), findsOneWidget);

      await tester.tap(find.text('Reset'));
      await tester.pumpAndSettle();

      expect(find.text('All'), findsOneWidget);
      expect(find.text('Date'), findsOneWidget);
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
