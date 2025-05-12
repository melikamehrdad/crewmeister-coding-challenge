class Absence {
  final int? admitterId;
  final String admitterNote;
  final String? confirmedAt;
  final String createdAt;
  final int crewId;
  final String endDate;
  final int id;
  final String memberNote;
  final String? rejectedAt;
  final String startDate;
  final String type;
  final int userId;
  final String status;
  final String memberName;
  final String memberImage;

  Absence({
    this.admitterId,
    required this.admitterNote,
    this.confirmedAt,
    required this.createdAt,
    required this.crewId,
    required this.endDate,
    required this.id,
    required this.memberNote,
    this.rejectedAt,
    required this.startDate,
    required this.type,
    required this.userId,
    required this.status,
    required this.memberName,
    required this.memberImage,
  });

  factory Absence.fromEntity(Map<String, dynamic> json) {
    String status;
    if (json['confirmedAt'] != null) {
      status = 'Confirmed';
    } else if (json['rejectedAt'] != null) {
      status = 'Rejected';
    } else {
      status = 'Requested';
    }

    return Absence(
      admitterId: json['admitterId'] as int?,
      admitterNote: json['admitterNote'] as String,
      confirmedAt: json['confirmedAt'] as String?,
      createdAt: json['createdAt'] as String,
      crewId: json['crewId'] as int,
      endDate: json['endDate'] as String,
      id: json['id'] as int,
      memberNote: json['memberNote'] as String,
      rejectedAt: json['rejectedAt'] as String?,
      startDate: json['startDate'] as String,
      type: json['type'] as String,
      userId: json['userId'] as int,
      status: status,
      memberName: json['memberName'] as String,
      memberImage: json['memberImage'] as String,
    );
  }

  Map<String, dynamic> toEntity() {
    return {
      'admitterId': admitterId,
      'admitterNote': admitterNote,
      'confirmedAt': confirmedAt,
      'createdAt': createdAt,
      'crewId': crewId,
      'endDate': endDate,
      'id': id,
      'memberNote': memberNote,
      'rejectedAt': rejectedAt,
      'startDate': startDate,
      'type': type,
      'userId': userId,
      'status': status,
      'memberName': memberName,
      'memberImage': memberImage,
    };
  }
}
