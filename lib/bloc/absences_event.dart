part of 'absences_bloc.dart';

abstract class AbsencesEvent extends Equatable {
  const AbsencesEvent();

  @override
  List<Object> get props => [];
}

class AbsencesFetched extends AbsencesEvent {}

class AbsencesLoadMore extends AbsencesEvent {
  final int pageNumber;
  final String? filterType;
  final DateTimeRange? dateRange;

  const AbsencesLoadMore(
      {required this.pageNumber, this.filterType, this.dateRange});
}

class AbsencesFiltered extends AbsencesEvent {
  final String filterType;
  final DateTimeRange? dateRange;

  const AbsencesFiltered({
    required this.filterType,
    this.dateRange,
  });
}

class AbsencesExportDataFileCreated extends AbsencesEvent {}
