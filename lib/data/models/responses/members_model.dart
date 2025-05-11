class MembersResponseModel {
  final String message;
  final List<MemberModel> payload;

  MembersResponseModel({
    required this.message,
    required this.payload,
  });

  factory MembersResponseModel.fromJson(Map<String, dynamic> json) {
    return MembersResponseModel(
      message: json['message'],
      payload: List<MemberModel>.from(json['payload'].map((x) => MemberModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'payload': List<dynamic>.from(payload.map((x) => x.toJson())),
    };
  }
}

class MemberModel {
  final int crewId;
  final int id;
  final String image;
  final String name;
  final int userId;

  MemberModel({
    required this.crewId,
    required this.id,
    required this.image,
    required this.name,
    required this.userId,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      crewId: json['crewId'],
      id: json['id'],
      image: json['image'],
      name: json['name'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'crewId': crewId,
      'id': id,
      'image': image,
      'name': name,
      'userId': userId,
    };
  }
}