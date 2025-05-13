class ExportDataRequest {
  final String memberName;
  final String absenceType;
  final String startDate;
  final String endDate;
  final String? memberNote;
  final String? admitterNote;
  final String status;

  ExportDataRequest({
    required this.memberName,
    required this.absenceType,
    required this.startDate,
    required this.endDate,
    this.memberNote,
    this.admitterNote,
    required this.status,
  });

  factory ExportDataRequest.fromEntity(Map<String, dynamic> json) {
    return ExportDataRequest(
      memberName: json['memberName'] as String,
      absenceType: json['absenceType'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      memberNote: json['memberNote'] as String?,
      admitterNote: json['admitterNote'] as String?,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toEntity() {
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
