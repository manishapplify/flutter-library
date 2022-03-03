abstract class BaseResponse {
  BaseResponse(this.statusCode, this.message);

  final int statusCode;
  final String message;
}
