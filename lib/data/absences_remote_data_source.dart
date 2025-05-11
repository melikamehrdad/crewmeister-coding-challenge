import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import 'package:code_challenge/data/models/requests/requests.dart';
import 'package:code_challenge/data/models/responses/responses.dart';

final String absencesJsonPath = 'assets/json/absences.json';

class AbsencesRemoteDataSource {
  Future<AllAbsencesModel> getAbsences(
      AbsencesRequestModel absencesRequestModel) async {
    try {
      final String content = await rootBundle.loadString(absencesJsonPath);
      final Map<String, dynamic> json = jsonDecode(content);
      final absencesJson = json['payload'] as List;
      int start =
          (absencesRequestModel.pageNumber - 1) * absencesRequestModel.pageSize;
      int end = start + absencesRequestModel.pageSize;
      if (start >= absencesJson.length) {
        return AllAbsencesModel(
          totalCount: 0,
          absences: [],
        );
      }
      end = end > absencesJson.length ? absencesJson.length : end;
      List<AbsenceModel> absencesPaginatedList = absencesJson
          .sublist(start, end)
          .map((e) => AbsenceModel.fromJson(e))
          .toList();
      final AllAbsencesModel allAbsencesModel = AllAbsencesModel(
        totalCount: absencesJson.length,
        absences: absencesPaginatedList,
      );

      return allAbsencesModel;
    } catch (e) {
      throw Exception('Error loading absences: $e');
    }
  }
}
