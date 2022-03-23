class FeedbackSecondRequest {
  FeedbackSecondRequest({
    required this.comment,
    required this.rating,
    required this.title,
    required this.type,
  });

  final String comment;
  final int rating;
  final String title;
  final String type;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'comment': comment,
        'rating': rating,
        'title': title,
        'type': type,
      };
}
