part of 'absences_bloc.dart';

abstract class AbsencesEvent extends Equatable {
  const AbsencesEvent();

  @override
  List<Object> get props => [];
}

class AbsencesFetched extends AbsencesEvent {}

class AbsencesLoadMore extends AbsencesEvent {
  final int startIndex;

  const AbsencesLoadMore(this.startIndex);

  @override
  List<Object> get props => [startIndex];
}

class AbsencesFiltered extends AbsencesEvent {
  final String filter;

  const AbsencesFiltered(this.filter);

  @override
  List<Object> get props => [filter];
}
