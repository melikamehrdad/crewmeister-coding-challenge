import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../domain/entities/entities.dart';

part 'absences_event.dart';
part 'absences_state.dart';

class AbsencesBloc extends Bloc<AbsencesEvent, AbsencesState> {
  AbsencesBloc() : super(const AbsencesState()) {
    on<AbsencesFetched>(_onFetched);
    on<AbsencesLoadMore>(_onLoadMore);
    on<AbsencesFiltered>(_onFiltered);
  }

  Future<void> _onFetched(
      AbsencesFetched event, Emitter<AbsencesState> emit) async {}

  Future<void> _onLoadMore(
      AbsencesLoadMore event, Emitter<AbsencesState> emit) async {}

  Future<void> _onFiltered(
      AbsencesFiltered event, Emitter<AbsencesState> emit) async {}
}
