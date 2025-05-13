import 'dart:convert';
import 'package:code_challenge/utils.dart/constants.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:code_challenge/data/models/requests/requests.dart';
import 'package:code_challenge/data/models/responses/responses.dart';

class AbsencesRemoteDataSource {
  Future<AllAbsencesModel> getAbsences(
      AbsencesRequestModel absencesRequestModel) async {
    try {
      final absencesJson = await _loadJson(Constants.absencesJsonPath);
      final membersJson = await _loadJson(Constants.membersJsonPath);

      final absencesList = _parseAbsences(absencesJson);
      final membersList = _parseMembers(membersJson);

      _assignMemberInfoToAbsences(absencesList, membersList);

      return AllAbsencesModel(
        totalCount: absencesList.length,
        absences: absencesList,
      );
    } catch (e) {
      throw Exception('Error loading absences: $e');
    }
  }

  Future<Map<String, dynamic>> _loadJson(String path) async {
    final content = await rootBundle.loadString(path);
    return jsonDecode(content) as Map<String, dynamic>;
  }

  List<AbsenceModel> _parseAbsences(Map<String, dynamic> json) {
    final absencesJson = json['payload'] as List;
    return absencesJson.map((e) => AbsenceModel.fromJson(e)).toList();
  }

  List<MemberModel> _parseMembers(Map<String, dynamic> json) {
    final membersJson = json['payload'] as List;
    return membersJson.map((e) => MemberModel.fromJson(e)).toList();
  }

  void _assignMemberInfoToAbsences(
      List<AbsenceModel> absences, List<MemberModel> members) {
    for (var absence in absences) {
      final member = members.firstWhere(
        (member) => member.userId == absence.userId,
      );
      absence.assignMemberInfo(member);
    }
  }
}
