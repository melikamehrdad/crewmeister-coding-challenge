import 'package:bloc_test/bloc_test.dart';
import 'package:code_challenge/bloc/absences_bloc.dart';
import 'package:code_challenge/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAbsencesRepository extends Mock implements AbsencesRepository {}

void main() {
  late AbsencesBloc absencesBloc;
  late MockAbsencesRepository mockAbsencesRepository;

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
        when(() => mockAbsencesRepository.getAbsences(any()))
            .thenAnswer((_) async => AllAbsences(absences: [], totalCount: 0));
        return absencesBloc;
      },
      act: (bloc) => bloc.add(AbsencesFetched()),
      expect: () => [
        const AbsencesState(status: AbsencesStatus.loading),
        const AbsencesState(
            status: AbsencesStatus.success,
            absences: [],
            totalAbsencesCount: 0),
      ],
      verify: (_) {
        verify(() => mockAbsencesRepository.getAbsences(any())).called(1);
      },
    );

    blocTest<AbsencesBloc, AbsencesState>(
      'emits [loading, failure] when an error occurs during fetch',
      build: () {
        when(() => mockAbsencesRepository.getAbsences(any()))
            .thenThrow(Exception('Failed to load data'));
        return absencesBloc;
      },
      act: (bloc) => bloc.add(AbsencesFetched()),
      expect: () => [
        const AbsencesState(status: AbsencesStatus.loading),
        const AbsencesState(
            status: AbsencesStatus.failure,
            errorMessage: 'Exception: Failed to load data'),
      ],
      verify: (_) {
        verify(() => mockAbsencesRepository.getAbsences(any())).called(1);
      },
    );

    blocTest<AbsencesBloc, AbsencesState>(
      'emits [loading, success] when more data is loaded successfully',
      build: () {
        when(() => mockAbsencesRepository.getAbsences(any()))
            .thenAnswer((_) async => AllAbsences(
                  absences: [...mockAbsences],
                  totalCount: 3,
                ));
        return absencesBloc;
      },
      seed: () => AbsencesState(
        status: AbsencesStatus.success,
        absences: mockAbsences,
        totalAbsencesCount: 3,
      ),
      act: (bloc) {
        bloc.add(AbsencesLoadMore(pageNumber: 2));
      },
      expect: () => [
        AbsencesState(
          status: AbsencesStatus.success,
          absences: mockAbsences,
          totalAbsencesCount: 3,
          hasReachedMax: true,
        ),
        AbsencesState(
          status: AbsencesStatus.loading,
          absences: mockAbsences,
          totalAbsencesCount: 3,
          hasReachedMax: true,
        ),
        AbsencesState(
          status: AbsencesStatus.success,
          correctPageNumber: 2,
          absences: mockAbsences + mockAbsences,
          totalAbsencesCount: 3,
        ),
      ],
      verify: (_) {
        verify(() => mockAbsencesRepository.getAbsences(any())).called(1);
      },
    );

    blocTest<AbsencesBloc, AbsencesState>(
      'emits [loading, success] when filters are applied successfully',
      build: () {
        when(() => mockAbsencesRepository.getAbsences(any()))
            .thenAnswer((_) async => AllAbsences(
                  absences: mockAbsences,
                  totalCount: 3,
                ));
        return absencesBloc;
      },
      seed: () => AbsencesState(
        status: AbsencesStatus.success,
        absences: mockAbsences,
        totalAbsencesCount: 3,
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
          totalAbsencesCount: 3,
        ),
        AbsencesState(
          status: AbsencesStatus.success,
          absences: [
            mockAbsences[0],
            mockAbsences[2],
          ],
          totalAbsencesCount: 3,
        ),
      ],
      verify: (_) {
        verify(() => mockAbsencesRepository.getAbsences(any())).called(1);
      },
    );

    blocTest<AbsencesBloc, AbsencesState>(
      'emits [failure] when error occurs while filtering',
      build: () {
        when(() => mockAbsencesRepository.getAbsences(any()))
            .thenThrow(Exception('Failed to load filtered data'));
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
  });
}
