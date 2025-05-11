import 'package:code_challenge/domain/entities/responses/absence.dart';

class AllAbsences {
  final int totalCount;
  final List<Absence> absences;

  AllAbsences({
    required this.totalCount,
    required this.absences,
  });

  factory AllAbsences.fromEntity(Map<String, dynamic> json) {
    return AllAbsences(
      totalCount: json['totalCount'] as int,
      absences: (json['absences'] as List<dynamic>)
          .map((item) => Absence.fromEntity(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toEntity() {
    return {
      'totalCount': totalCount,
      'absences': absences.map((absence) => absence.toEntity()).toList(),
    };
  }
}
