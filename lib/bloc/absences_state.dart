part of 'absences_bloc.dart';

enum AbsencesStatus { loading, success, failure, fileExported }

class AbsencesState extends Equatable {
  final int correctPageNumber;
  final AbsencesStatus status;
  final int totalAbsencesCount;
  final List<Absence> absences;
  final bool hasReachedMax;
  final String errorMessage;
  final String selectedType;
  final DateTimeRange? selectedDateRange;

  const AbsencesState({
    this.correctPageNumber = 1,
    this.status = AbsencesStatus.loading,
    this.totalAbsencesCount = 0,
    this.absences = const [],
    this.hasReachedMax = false,
    this.errorMessage = '',
    this.selectedType = 'All',
    this.selectedDateRange,
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
  }) {
    return AbsencesState(
      correctPageNumber: correctPageNumber ?? this.correctPageNumber,
      status: status ?? this.status,
      totalAbsencesCount: totalAbsencesCount ?? this.totalAbsencesCount,
      absences: absences ?? this.absences,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedType: selectedType ?? this.selectedType,
      selectedDateRange: selectedDateRange,
    );
  }

  @override
  List<Object?> get props => [
        correctPageNumber,
        status,
        absences,
        totalAbsencesCount,
        hasReachedMax,
        errorMessage,
        selectedType,
        selectedDateRange,
      ];
}
