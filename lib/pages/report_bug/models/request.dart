class ReportBugRequest {
  ReportBugRequest({
    required this.title,
    required this.description,
    required this.image,
  });

  final String title;
  final String description;
  final String image;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': title,
        'description': description,
        'image': image,
      };
}
