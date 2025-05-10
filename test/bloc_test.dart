import 'package:bloc_test/bloc_test.dart';
import 'package:code_challenge/bloc/absences_bloc.dart';
import 'package:code_challenge/domain/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  final Absence absence = Absence(
    admitterId: null,
    admitterNote:
        "Leider sind Wolfram und Phillip schon im Urlaub. Geh lieber mal im März",
    confirmedAt: null,
    createdAt: "2021-02-14T15:41:26.000+01:00",
    crewId: 352,
    endDate: "2021-02-25",
    id: 3235,
    memberNote: "Skiurlaub",
    rejectedAt: "2021-02-14T15:43:06.000+01:00",
    startDate: "2021-02-20",
    type: "vacation",
    userId: 644,
    status: "rejected",
  );

  group('AbsencesBloc', () {
    blocTest<AbsencesBloc, AbsencesState>(
      'emits [AbsencesLoading, AbsencesLoaded] when absences are fetched successfully',
      build: () {
        return AbsencesBloc();
      },
      act: (bloc) => bloc.add(AbsencesFetched()),
      expect: () => [
        const AbsencesState(
            status: AbsencesStatus.success, absences: [], hasReachedMax: false),
      ],
    );

    blocTest<AbsencesBloc, AbsencesState>(
      'emits [AbsencesLoading, AbsencesError] when fetching absences fails',
      build: () {
        return AbsencesBloc();
      },
      act: (bloc) => bloc.add(AbsencesFetched()),
      expect: () => [
        const AbsencesState(
            status: AbsencesStatus.failure, absences: [], hasReachedMax: false),
      ],
    );

    blocTest<AbsencesBloc, AbsencesState>(
      'emits [AbsencesLoaded] with filtered absences when FilterAbsencesEvent is added',
      build: () {
        return AbsencesBloc();
      },
      act: (bloc) async {
        bloc.add(AbsencesFetched());
        await Future.delayed(Duration.zero);
        bloc.add(AbsencesFiltered('vacation'));
      },
      expect: () => [
        AbsencesState(
            status: AbsencesStatus.success,
            absences: [
              absence,
              Absence(
                admitterId: null,
                admitterNote:
                    "Leider sind Wolfram und Phillip schon im Urlaub. Geh lieber mal im März",
                confirmedAt: null,
                createdAt: "2021-02-14T15:41:26.000+01:00",
                crewId: 352,
                endDate: "2021-02-25",
                id: 3235,
                memberNote: "Skiurlaub",
                rejectedAt: "2021-02-14T15:43:06.000+01:00",
                startDate: "2021-02-20",
                type: "sickness",
                userId: 644,
                status: "rejected",
              ),
            ],
            hasReachedMax: false),
        AbsencesState(
          status: AbsencesStatus.success,
          absences: [
            absence,
          ],
          hasReachedMax: false,
        ),
      ],
    );

    blocTest<AbsencesBloc, AbsencesState>(
      'emits [AbsencesLoaded] with more absences when LoadMoreAbsencesEvent is added',
      build: () {
        return AbsencesBloc();
      },
      act: (bloc) async {
        bloc.add(AbsencesFetched());
        await Future.delayed(Duration.zero);
        bloc.add(AbsencesLoadMore(1));
      },
      expect: () => [
        AbsencesState(
          status: AbsencesStatus.success,
          absences: [
            absence,
            Absence(
              admitterId: null,
              admitterNote:
                  "Leider sind Wolfram und Phillip schon im Urlaub. Geh lieber mal im März",
              confirmedAt: null,
              createdAt: "2021-02-14T15:41:26.000+01:00",
              crewId: 352,
              endDate: "2021-02-25",
              id: 3235,
              memberNote: "Skiurlaub",
              rejectedAt: "2021-02-14T15:43:06.000+01:00",
              startDate: "2021-02-20",
              type: "sickness",
              userId: 644,
              status: "rejected",
            ),
          ],
          hasReachedMax: false,
        ),
        AbsencesState(
          status: AbsencesStatus.success,
          absences: [
            absence,
          ],
          hasReachedMax: false,
        ),
      ],
    );
  });
}
