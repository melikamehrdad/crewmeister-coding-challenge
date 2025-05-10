class MembersResponse {
  final String message;
  final List<Member> payload;

  MembersResponse({
    required this.message,
    required this.payload,
  });

  factory MembersResponse.fromJson(Map<String, dynamic> json) {
    return MembersResponse(
      message: json['message'],
      payload: List<Member>.from(json['payload'].map((x) => Member.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'payload': List<dynamic>.from(payload.map((x) => x.toJson())),
    };
  }
}

class Member {
  final int crewId;
  final int id;
  final String image;
  final String name;
  final int userId;

  Member({
    required this.crewId,
    required this.id,
    required this.image,
    required this.name,
    required this.userId,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
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