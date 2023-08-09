import 'package:clean_framework_legacy/clean_framework.dart';
import 'package:clean_framework_legacy/clean_framework_defaults.dart';

typedef ModelCallback<M extends ServiceResponseModel> = void Function(M model);

class JsonResponseBlocHandler<B extends ErrorPublisherBloc,
    M extends JsonResponseModel> implements JsonServiceResponseHandler<M> {
  B bloc;
  final ModelCallback<M> success;
  bool hadError = false;

  JsonResponseBlocHandler({required this.bloc, required this.success});

  @override
  void onError(RestResponseType responseType, String response) {
    bloc.handleError(PublishedErrorType.general);
    hadError = true;
  }

  @override
  void onMissingPathData(Map<String, dynamic> requestJson) {
    bloc.handleError(PublishedErrorType.general);
    hadError = true;
  }

  @override
  void onInvalidRequest(Map<String, dynamic>? requestJson) {
    bloc.handleError(PublishedErrorType.general);
    hadError = true;
  }

  @override
  void onInvalidResponse(String response) {
    bloc.handleError(PublishedErrorType.general);
    hadError = true;
  }

  @override
  void onNoConnectivity() {
    bloc.handleError(PublishedErrorType.noConnectivity);
    hadError = true;
  }

  @override
  void onSuccess(M model) => success(model);
}
