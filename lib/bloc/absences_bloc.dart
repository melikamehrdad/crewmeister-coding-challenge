import 'package:code_challenge/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'absences_event.dart';
part 'absences_state.dart';

class AbsencesBloc extends Bloc<AbsencesEvent, AbsencesState> {
  final AbsencesRepository _absencesRepository;

  AbsencesBloc(this._absencesRepository) : super(const AbsencesState()) {
    on<AbsencesFetched>(_onAbsencesFetched);
    on<AbsencesLoadMore>(_onAbsencesLoadMore);
    on<AbsencesFiltered>(_onAbsencesFiltered);
  }

  Future<void> _onAbsencesFetched(
      AbsencesFetched event, Emitter<AbsencesState> emit) async {
    await _handleAbsencesRequest(
      emit: emit,
      pageNumber: state.correctPageNumber,
      onSuccess: (AllAbsences response) {
        emit(state.copyWith(
          status: AbsencesStatus.success,
          absences: response.absences,
          totalAbsencesCount: response.totalCount,
        ));
      },
    );
  }

  Future<void> _onAbsencesLoadMore(
      AbsencesLoadMore event, Emitter<AbsencesState> emit) async {
    if (state.status != AbsencesStatus.success) return;

    emit(state.copyWith(hasReachedMax: true));
    final currentAbsences = state.absences;

    await _handleAbsencesRequest(
      emit: emit,
      pageNumber: event.pageNumber,
      onSuccess: (AllAbsences response) {
        final filteredAbsences = applyFilters(
          response.absences,
          event.filterType ?? 'All',
          event.dateRange,
        );
        emit(state.copyWith(
          correctPageNumber: event.pageNumber,
          status: AbsencesStatus.success,
          absences: currentAbsences + filteredAbsences,
          totalAbsencesCount: response.totalCount,
          hasReachedMax: false,
        ));
      },
    );
  }

  Future<void> _onAbsencesFiltered(
      AbsencesFiltered event, Emitter<AbsencesState> emit) async {
    if (state.status != AbsencesStatus.success) {
      emit(state.copyWith(
          status: AbsencesStatus.failure,
          errorMessage: 'Error applying filters.'));
      return;
    }

    await _handleAbsencesRequest(
      emit: emit,
      pageNumber: 1,
      onSuccess: (AllAbsences response) {
        final filteredAbsences =
            applyFilters(response.absences, event.filterType, event.dateRange);
        emit(state.copyWith(
          status: AbsencesStatus.success,
          absences: filteredAbsences,
          totalAbsencesCount: response.totalCount,
        ));
      },
    );
  }

  Future<void> _handleAbsencesRequest({
    required Emitter<AbsencesState> emit,
    required int pageNumber,
    required Function(AllAbsences response) onSuccess,
  }) async {
    emit(state.copyWith(status: AbsencesStatus.loading));
    try {
      final response = await _absencesRepository.getAbsences(
        AbsencesRequest(
          pageNumber: pageNumber,
          pageSize: 10,
        ),
      );
      onSuccess(response);
    } catch (e) {
      emit(state.copyWith(
          status: AbsencesStatus.failure, errorMessage: e.toString()));
    }
  }
}

List<Absence> applyFilters(List<Absence> absences, String filterType,
    DateTimeRange? selectedDateRange) {
  return absences.where((absence) {
    final matchType = filterType == 'All' || absence.type == filterType;
    final matchDate = selectedDateRange == null ||
        (DateTime.parse(absence.startDate).isAfter(selectedDateRange.start) &&
            DateTime.parse(absence.endDate).isBefore(selectedDateRange.end));
    return matchType && matchDate;
  }).toList();
}
