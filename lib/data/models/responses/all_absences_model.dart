import 'package:code_challenge/data/models/responses/responses.dart';

class AllAbsencesModel {
  final int totalAbsenceRequestCount;
  final List<AbsenceModel> absenceRequests;

  AllAbsencesModel({
    required this.totalAbsenceRequestCount,
    required this.absenceRequests,
  });

  factory AllAbsencesModel.fromJson(Map<String, dynamic> json) {
    return AllAbsencesModel(
      totalAbsenceRequestCount: json['totalAbsenceRequestCount'] as int,
      absenceRequests: (json['absenceRequests'] as List<dynamic>)
          .map((item) => AbsenceModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalAbsenceRequestCount': totalAbsenceRequestCount,
      'absenceRequests': absenceRequests.map((absence) => absence.toJson()).toList(),
    };
  }
}
