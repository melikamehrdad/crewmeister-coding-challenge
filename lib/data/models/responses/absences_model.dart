import 'package:code_challenge/data/models/responses/responses.dart';

class AbsenceModel {
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
  String? memberName;
  String? memberImage;

  AbsenceModel({
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
    this.memberName,
    this.memberImage,
  });

  factory AbsenceModel.fromJson(Map<String, dynamic> json) {
    return AbsenceModel(
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
      memberName: json['memberName'] as String?,
      memberImage: json['memberImage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
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
      'memberName': memberName ?? 'Unknown',
      'memberImage': memberImage ?? 'Unknown',
    };
  }

  void assignMemberInfo(MemberModel member) {
    if (userId == member.userId) {
      memberName = member.name;
      memberImage = member.image;
    }
  }
}
