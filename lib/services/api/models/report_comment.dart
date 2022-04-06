import 'package:components/services/api/models/report_item.dart';

class ReportCommentRequest extends ReportItemRequest {
  ReportCommentRequest({
    String? itemId,
    required String description,
  }) : super(
            description: description,
            itemType: 'COMMENT',
            itemId: itemId);
}
