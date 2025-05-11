import 'package:code_challenge/data/models/responses/responses.dart';

class AllAbsencesModel {
  final int totalCount;
  final List<AbsenceModel> absences;

  AllAbsencesModel({
    required this.totalCount,
    required this.absences,
  });

  factory AllAbsencesModel.fromJson(Map<String, dynamic> json) {
    return AllAbsencesModel(
      totalCount: json['totalCount'] as int,
      absences: (json['absences'] as List<dynamic>)
          .map((item) => AbsenceModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCount': totalCount,
      'absences': absences.map((absence) => absence.toJson()).toList(),
    };
  }
}