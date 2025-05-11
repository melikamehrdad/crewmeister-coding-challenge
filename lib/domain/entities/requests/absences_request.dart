class AbsencesRequest {
  final int pageNumber;
  final int pageSize;

  AbsencesRequest({
    required this.pageNumber,
    required this.pageSize,
  });

  Map<String, dynamic> toEntity() {
    return {
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };
  }

  factory AbsencesRequest.fromEntity(Map<String, dynamic> json) {
    return AbsencesRequest(
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
    );
  }
}
