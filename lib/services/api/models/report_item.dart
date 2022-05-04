abstract class ReportItemRequest {
  ReportItemRequest({
    this.itemId,
    required this.itemType,
    required this.description,
  });

  final String? itemId;
  final String itemType;
  final String description;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{
      'itemType': itemType,
      'description': description,
    };

    if (itemId is String && itemId!.isNotEmpty) {
      map['itemId'] = itemId;
    }

    return map;
  }
}
