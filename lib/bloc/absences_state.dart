part of 'absences_bloc.dart';

enum AbsencesStatus { loading, success, failure }

class AbsencesState extends Equatable {
  final int correctPageNumber;
  final AbsencesStatus status;
  final int totalAbsencesCount;
  final List<Absence> absences;
  final bool hasReachedMax;
  final String errorMessage;

  const AbsencesState({
    this.correctPageNumber = 1,
    this.status = AbsencesStatus.loading,
    this.totalAbsencesCount = 0,
    this.absences = const [],
    this.hasReachedMax = false,
    this.errorMessage = '',
  });

  AbsencesState copyWith({
    int? correctPageNumber,
    AbsencesStatus? status,
    int? totalAbsencesCount,
    List<Absence>? absences,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return AbsencesState(
      correctPageNumber: correctPageNumber ?? this.correctPageNumber,
      status: status ?? this.status,
      totalAbsencesCount: totalAbsencesCount ?? this.totalAbsencesCount,
      absences: absences ?? this.absences,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        correctPageNumber,
        status,
        absences,
        totalAbsencesCount,
        hasReachedMax,
        errorMessage
      ];
}
