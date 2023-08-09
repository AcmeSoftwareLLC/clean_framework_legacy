import 'package:clean_framework_legacy/clean_framework.dart';

class RestApiMock<C extends Object> extends RestApi {
  C _content;
  RestResponseType _responseType;

  RestApiMock({
    required C content,
    RestResponseType responseType = RestResponseType.success,
  })  : _content = content,
        _responseType = responseType;

  @override
  Future<RestResponse<C>> request({
    required RestMethod method,
    required String path,
    Map<String, dynamic> requestBody = const {},
  }) async {
    return RestResponse<C>(
      type: _responseType,
      uri: Uri.http('', path),
      content: _content,
    );
  }

  @override
  Future<RestResponse<C>> requestBinary({
    required RestMethod method,
    required String path,
    Map<String, dynamic> requestBody = const {},
  }) async {
    return RestResponse<C>(
      type: _responseType,
      uri: Uri.http('', path),
      content: _content,
    );
  }
}
