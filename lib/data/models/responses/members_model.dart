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