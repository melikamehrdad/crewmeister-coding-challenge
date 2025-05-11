class AbsencesRequestModel {
  final int pageNumber;
  final int pageSize;

  AbsencesRequestModel({
    required this.pageNumber,
    required this.pageSize,
  });

  Map<String, dynamic> toJson() {
    return {
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };
  }
}