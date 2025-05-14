import 'package:bloc_test/bloc_test.dart';
import 'package:code_challenge/presentation/bloc/absences_bloc.dart';
import 'package:code_challenge/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_test_data.dart';

class MockAbsencesRepository extends Mock implements AbsencesRepository {}

void main() {
  late AbsencesBloc absencesBloc;
  late MockAbsencesRepository mockAbsencesRepository;

  setUp(() {
    mockAbsencesRepository = MockAbsencesRepository();
    absencesBloc = AbsencesBloc(mockAbsencesRepository);
  });

  group('AbsencesBloc', () {
    test('initial state is AbsencesState()', () {
      expect(absencesBloc.state, const AbsencesState());
    });

    blocTest<AbsencesBloc, AbsencesState>(
      'emits [loading, success] when data is fetched successfully',
      build: () {
        when(() => mockAbsencesRepository.getAbsences())
            .thenAnswer((_) async => AllAbsences(
                  absenceRequests: [],
                  totalAbsenceRequestsCount: 0,
                ));
        return absencesBloc;
      },
      act: (bloc) => bloc.add(AbsencesFetched()),
      expect: () => [
        const AbsencesState(status: AbsencesStatus.loading),
        const AbsencesState(
          status: AbsencesStatus.success,
          absences: [],
          totalAbsencesRequestCount: 0,
          todayTotalAbsencesCount: 0,
          totalAbsencesCount: 0,
        ),
      ],
      verify: (_) {
        verify(() => mockAbsencesRepository.getAbsences()).called(1);
      },
    );

    blocTest<AbsencesBloc, AbsencesState>(
      'emits [loading, failure] when an error occurs during fetch',
      build: () {
        when(() => mockAbsencesRepository.getAbsences())
            .thenThrow(Exception('Failed to load data'));
        return absencesBloc;
      },
      act: (bloc) => bloc.add(AbsencesFetched()),
      expect: () => [
        const AbsencesState(status: AbsencesStatus.loading),
        const AbsencesState(
          status: AbsencesStatus.failure,
          errorMessage: 'Exception: Failed to load data',
        ),
      ],
      verify: (_) {
        verify(() => mockAbsencesRepository.getAbsences()).called(1);
      },
    );

    blocTest<AbsencesBloc, AbsencesState>(
      'emits [loading, success] when more data is loaded successfully',
      build: () {
        when(() => mockAbsencesRepository.getAbsences())
            .thenAnswer((_) async => AllAbsences(
                  absenceRequests: mockAbsences + mockAbsences,
                  totalAbsenceRequestsCount: 6,
                ));
        return absencesBloc;
      },
      seed: () => AbsencesState(
        status: AbsencesStatus.success,
        absences: mockAbsences,
        totalAbsencesRequestCount: 3,
        todayTotalAbsencesCount: 0,
        totalAbsencesCount: 2,
      ),
      act: (bloc) {
        bloc.add(AbsencesLoadMore(pageNumber: 2));
      },
      expect: () => [
        AbsencesState(
          status: AbsencesStatus.success,
          absences: mockAbsences,
          totalAbsencesRequestCount: 3,
          todayTotalAbsencesCount: 0,
          totalAbsencesCount: 2,
          hasReachedMax: true,
        ),
        AbsencesState(
          status: AbsencesStatus.loading,
          absences: mockAbsences,
          totalAbsencesRequestCount: 3,
          todayTotalAbsencesCount: 0,
          totalAbsencesCount: 2,
          hasReachedMax: true,
        ),
        AbsencesState(
          status: AbsencesStatus.success,
          correctPageNumber: 2,
          absences: mockAbsences + mockAbsences,
          totalAbsencesRequestCount: 6,
          todayTotalAbsencesCount: 0,
          totalAbsencesCount: 4,
        ),
      ],
      verify: (_) {
        verify(() => mockAbsencesRepository.getAbsences()).called(1);
      },
    );

    blocTest<AbsencesBloc, AbsencesState>(
      'emits [loading, success] when filters are applied successfully',
      build: () {
        when(() => mockAbsencesRepository.getAbsences())
            .thenAnswer((_) async => AllAbsences(
                  absenceRequests: mockAbsences,
                  totalAbsenceRequestsCount: 3,
                ));
        return absencesBloc;
      },
      seed: () => AbsencesState(
        status: AbsencesStatus.success,
        absences: mockAbsences,
        totalAbsencesRequestCount: 3,
        todayTotalAbsencesCount: 0,
        totalAbsencesCount: 2,
      ),
      act: (bloc) {
        bloc.add(AbsencesFiltered(
          filterType: 'vacation',
          dateRange: null,
        ));
      },
      expect: () => [
        AbsencesState(
          status: AbsencesStatus.loading,
          absences: mockAbsences,
          totalAbsencesRequestCount: 3,
          todayTotalAbsencesCount: 0,
          totalAbsencesCount: 2,
        ),
        AbsencesState(
          status: AbsencesStatus.success,
          absences: [
            mockAbsences[0],
            mockAbsences[2],
          ],
          selectedType: 'vacation',
          totalAbsencesRequestCount: 3,
          todayTotalAbsencesCount: 0,
          totalAbsencesCount: 2,
        ),
      ],
      verify: (_) {
        verify(() => mockAbsencesRepository.getAbsences()).called(1);
      },
    );

    blocTest<AbsencesBloc, AbsencesState>(
      'emits [failure] when error occurs while filtering',
      build: () {
        when(() => mockAbsencesRepository.getAbsences())
            .thenThrow(Exception('Error applying filters.'));
        return absencesBloc;
      },
      act: (bloc) =>
          bloc.add(AbsencesFiltered(filterType: 'vacation', dateRange: null)),
      expect: () => [
        const AbsencesState(
            status: AbsencesStatus.failure,
            errorMessage: 'Error applying filters.'),
      ],
    );

    blocTest<AbsencesBloc, AbsencesState>(
      'emits [loading, success] when export data file is created successfully',
      build: () {
        when(() => mockAbsencesRepository.createExportDataFile(any()))
            .thenAnswer((_) async => Future.value());
        return absencesBloc;
      },
      act: (bloc) => bloc.add(AbsencesExportDataFileCreated()),
      expect: () => [
        const AbsencesState(status: AbsencesStatus.loading),
        const AbsencesState(
            status: AbsencesStatus.fileExported, errorMessage: ''),
      ],
      verify: (_) {
        verify(() => mockAbsencesRepository.createExportDataFile(any()))
            .called(1);
      },
    );

    blocTest<AbsencesBloc, AbsencesState>(
      'emits [failure] when error occurs while creating export data file',
      build: () {
        when(() => mockAbsencesRepository.createExportDataFile(any()))
            .thenThrow(Exception('Failed to create export data file'));
        return absencesBloc;
      },
      act: (bloc) => bloc.add(AbsencesExportDataFileCreated()),
      expect: () => [
        const AbsencesState(status: AbsencesStatus.loading),
        const AbsencesState(
            status: AbsencesStatus.failure,
            errorMessage: 'Exception: Failed to create export data file'),
      ],
    );
  });
}
