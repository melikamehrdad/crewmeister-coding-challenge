import 'package:code_challenge/domain/entities/responses/absence.dart';

class AllAbsences {
  final int totalAbsenceRequestsCount;
  final List<Absence> absenceRequests;

  AllAbsences({
    required this.totalAbsenceRequestsCount,
    required this.absenceRequests,
  });

  factory AllAbsences.fromEntity(Map<String, dynamic> json) {
    return AllAbsences(
      totalAbsenceRequestsCount: json['totalAbsenceRequestsCount'] as int,
      absenceRequests: (json['absenceRequests'] as List<dynamic>)
          .map((item) => Absence.fromEntity(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toEntity() {
    return {
      'totalAbsenceRequestsCount': totalAbsenceRequestsCount,
      'absenceRequests': absenceRequests.map((absence) => absence.toEntity()).toList(),
    };
  }
}
