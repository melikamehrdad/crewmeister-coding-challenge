part of 'absences_bloc.dart';

enum AbsencesStatus { loading, success, failure, fileExported }

class AbsencesState extends Equatable {
  final int correctPageNumber;
  final AbsencesStatus status;
  final int totalAbsencesRequestCount;
  final List<Absence> absences;
  final bool hasReachedMax;
  final String errorMessage;
  final String selectedType;
  final DateTimeRange? selectedDateRange;
  final int todayTotalAbsencesCount;
  final int totalAbsencesCount;

  const AbsencesState({
    this.correctPageNumber = 1,
    this.status = AbsencesStatus.loading,
    this.totalAbsencesRequestCount = 0,
    this.absences = const [],
    this.hasReachedMax = false,
    this.errorMessage = '',
    this.selectedType = 'All',
    this.selectedDateRange,
    this.todayTotalAbsencesCount = 0,
    this.totalAbsencesCount = 0,
  });

  AbsencesState copyWith({
    int? correctPageNumber,
    AbsencesStatus? status,
    int? totalAbsencesCount,
    List<Absence>? absences,
    bool? hasReachedMax,
    String? errorMessage,
    String? selectedType,
    DateTimeRange? selectedDateRange,
    int? todayTotalAbsencesCount,
    int? totalAbsencesRequestCount,
  }) {
    return AbsencesState(
      correctPageNumber: correctPageNumber ?? this.correctPageNumber,
      status: status ?? this.status,
      totalAbsencesRequestCount:
          totalAbsencesRequestCount ?? this.totalAbsencesRequestCount,
      absences: absences ?? this.absences,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedType: selectedType ?? this.selectedType,
      selectedDateRange: selectedDateRange,
      todayTotalAbsencesCount:
          todayTotalAbsencesCount ?? this.todayTotalAbsencesCount,
      totalAbsencesCount: totalAbsencesCount ?? this.totalAbsencesCount,
    );
  }

  @override
  List<Object?> get props => [
        correctPageNumber,
        status,
        absences,
        totalAbsencesRequestCount,
        hasReachedMax,
        errorMessage,
        selectedType,
        selectedDateRange,
        todayTotalAbsencesCount,
        totalAbsencesCount,
      ];
}
