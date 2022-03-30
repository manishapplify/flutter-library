class FeedbackRequest {
  FeedbackRequest({
    required this.comment,
    required this.rating,
    required this.title,
    required this.type,
  });

  final String? comment;
  final int rating;
  final String title;
  final String type;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{
      'rating': rating,
      'title': title,
      'type': type,
    };

    if (comment is String) {
      map['comment'] = comment;
    }

    return map;
  }
}
