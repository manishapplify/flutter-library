import 'package:components/services/api/models/report_item.dart';

class ReportPostRequest extends ReportItemRequest {
  ReportPostRequest({
    String? itemId,
    required String description,
  }) : super(
          description: description,
          itemType: 'POST',
          itemId: itemId,
        );
}
