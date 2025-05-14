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
    on<AbsencesExportDataFileCreated>(_onExportDataFileCreated);
  }

  Future<void> _onAbsencesFetched(
      AbsencesFetched event, Emitter<AbsencesState> emit) async {
    await _handleAbsencesRequest(
      emit: emit,
      pageNumber: state.correctPageNumber,
      filterType: state.selectedType,
      selectedDateRange: state.selectedDateRange,
      onSuccess: (AllAbsences response) {
        emit(state.copyWith(
          status: AbsencesStatus.success,
          absences: paginateAbsences(
            response.absenceRequests,
            state.correctPageNumber,
          ),
          totalAbsencesCount:
              _calculateConfirmedAbsencesRequest(response.absenceRequests),
          todayTotalAbsencesCount:
              _calculateTodayTotalAbsences(response.absenceRequests),
          totalAbsencesRequestCount: response.totalAbsenceRequestsCount,
        ));
      },
    );
  }

  Future<void> _onAbsencesLoadMore(
      AbsencesLoadMore event, Emitter<AbsencesState> emit) async {
    emit(state.copyWith(hasReachedMax: true));

    await _handleAbsencesRequest(
      emit: emit,
      pageNumber: event.pageNumber,
      filterType: event.filterType ?? state.selectedType,
      selectedDateRange: event.dateRange ?? state.selectedDateRange,
      onSuccess: (AllAbsences response) {
        final filteredAbsences = _applyFilters(
          response.absenceRequests,
          event.filterType ?? state.selectedType,
          event.dateRange ?? state.selectedDateRange,
        );
        emit(state.copyWith(
          correctPageNumber: event.pageNumber,
          status: AbsencesStatus.success,
          absences: filteredAbsences +
              paginateAbsences(
                filteredAbsences,
                event.pageNumber,
              ),
          totalAbsencesRequestCount: response.totalAbsenceRequestsCount,
          todayTotalAbsencesCount: state.todayTotalAbsencesCount,
          totalAbsencesCount:
              _calculateConfirmedAbsencesRequest(filteredAbsences),
          hasReachedMax: false,
          selectedType: event.filterType ?? state.selectedType,
          selectedDateRange: event.dateRange ?? state.selectedDateRange,
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
      filterType: event.filterType,
      selectedDateRange: event.dateRange ?? state.selectedDateRange,
      onSuccess: (AllAbsences response) {
        final filteredAbsences = _applyFilters(
          response.absenceRequests,
          event.filterType,
          event.dateRange,
        );
        emit(state.copyWith(
          status: AbsencesStatus.success,
          absences: paginateAbsences(
            filteredAbsences,
            1,
          ),
          totalAbsencesRequestCount: response.totalAbsenceRequestsCount,
          todayTotalAbsencesCount:
              _calculateTodayTotalAbsences(response.absenceRequests),
          totalAbsencesCount:
              _calculateConfirmedAbsencesRequest(filteredAbsences),
          selectedType: event.filterType,
          selectedDateRange: event.dateRange ?? state.selectedDateRange,
        ));
      },
    );
  }

  Future<void> _onExportDataFileCreated(
      AbsencesExportDataFileCreated event, Emitter<AbsencesState> emit) async {
    emit(state.copyWith(status: AbsencesStatus.loading));
    try {
      List<ExportDataRequest> absences = state.absences
          .map((absence) => ExportDataRequest(
                memberName: absence.memberName,
                startDate: absence.startDate,
                endDate: absence.endDate,
                absenceType: absence.type,
                status: absence.status.name,
                admitterNote: absence.admitterNote,
                memberNote: absence.memberNote,
              ))
          .toList();
      await _absencesRepository.createExportDataFile(absences);
      emit(state.copyWith(status: AbsencesStatus.fileExported));
    } catch (e) {
      emit(state.copyWith(
          status: AbsencesStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _handleAbsencesRequest({
    required Emitter<AbsencesState> emit,
    required int pageNumber,
    required String filterType,
    required DateTimeRange? selectedDateRange,
    required Function(AllAbsences response) onSuccess,
  }) async {
    emit(state.copyWith(status: AbsencesStatus.loading));
    try {
      final response = await _absencesRepository.getAbsences();
      onSuccess(response);
    } catch (e) {
      emit(state.copyWith(
          status: AbsencesStatus.failure, errorMessage: e.toString()));
    }
  }
}

int _calculateConfirmedAbsencesRequest(List<Absence> absences) {
  return absences
      .where((absence) => absence.status == AbsenceRequestStatus.confirmed)
      .length;
}

int _calculateTodayTotalAbsences(List<Absence> absences) {
  final today = DateTime.now();
  return absences.where((absence) {
    final startDate = DateTime.parse(absence.startDate);
    final endDate = DateTime.parse(absence.endDate);
    final isConfirmed = absence.status == AbsenceRequestStatus.confirmed;
    return startDate.isBefore(today) && endDate.isAfter(today) && isConfirmed;
  }).length;
}

List<Absence> _applyFilters(List<Absence> absences, String filterType,
    DateTimeRange? selectedDateRange) {
  return absences.where((absence) {
    final matchType = filterType == 'All' || absence.type == filterType;
    final matchDate = selectedDateRange == null ||
        (DateTime.parse(absence.startDate).isAfter(selectedDateRange.start) &&
                DateTime.parse(absence.endDate)
                    .isBefore(selectedDateRange.end) ||
            DateTime.parse(absence.startDate) == selectedDateRange.start ||
            DateTime.parse(absence.endDate) == selectedDateRange.end);
    return matchType && matchDate;
  }).toList();
}

List<Absence> paginateAbsences(List<Absence> absences, int pageNumber) {
  final start = (pageNumber - 1) * 10;
  final end = (start + 10).clamp(0, absences.length);

  if (start >= absences.length) {
    return [];
  }

  return absences.sublist(start, end);
}
