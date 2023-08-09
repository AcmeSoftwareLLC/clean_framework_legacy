import 'package:clean_framework_legacy/clean_framework.dart';
import 'package:clean_framework_legacy/clean_framework_defaults.dart';

class JsonServiceResponseHandlerMock<M extends JsonResponseModel>
    implements JsonServiceResponseHandler<M> {
  PublishedErrorType? errorType;
  M? responseModel;

  void reset() => errorType = null;

  @override
  void onError(RestResponseType responseType, String response) =>
      errorType = PublishedErrorType.general;

  @override
  void onInvalidRequest(Map<String, dynamic>? requestJson) =>
      errorType = PublishedErrorType.general;

  @override
  void onInvalidResponse(String response) =>
      errorType = PublishedErrorType.general;

  @override
  void onMissingPathData(Map<String, dynamic> requestJson) =>
      errorType = PublishedErrorType.general;

  @override
  void onNoConnectivity() {
    // TODO: implement onNoConnectivity
  }

  @override
  void onSuccess(M model) => responseModel = model;
}
