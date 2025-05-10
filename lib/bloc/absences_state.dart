part of 'absences_bloc.dart';

enum AbsencesStatus { initial, success, failure }

final class AbsencesState extends Equatable {
  const AbsencesState({
    this.status = AbsencesStatus.initial,
    this.absences = const <Absence>[],
    this.hasReachedMax = false,
  });

  final AbsencesStatus status;
  final List<Absence> absences;
  final bool hasReachedMax;

  AbsencesState copyWith({
    AbsencesStatus? status,
    List<Absence>? absences,
    bool? hasReachedMax,
  }) {
    return AbsencesState(
      status: status ?? this.status,
      absences: absences ?? this.absences,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''AbsencesState { status: $status, hasReachedMax: $hasReachedMax, absences: ${absences.length} }''';
  }

  @override
  List<Object> get props => [status, absences, hasReachedMax];
}