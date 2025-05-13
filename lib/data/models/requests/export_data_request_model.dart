class ExportDataRequestModel {
  final String memberName;
  final String absenceType;
  final String startDate;
  final String endDate;
  final String? memberNote;
  final String? admitterNote;
  final String status;

  ExportDataRequestModel({
    required this.memberName,
    required this.absenceType,
    required this.startDate,
    required this.endDate,
    this.memberNote,
    this.admitterNote,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'memberName': memberName,
      'absenceType': absenceType,
      'startDate': startDate,
      'endDate': endDate,
      'memberNote': memberNote ?? 'No member note',
      'admitterNote': admitterNote ?? 'No admitter note',
      'status': status,
    };
  }
}
