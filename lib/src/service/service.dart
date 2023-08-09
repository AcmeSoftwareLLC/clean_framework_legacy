import 'package:flutter/foundation.dart';

@immutable
abstract class ServiceResponseModel {}

@immutable
abstract class ServiceRequestModel {}

abstract class Service<R extends ServiceRequestModel,
    S extends ServiceResponseModel> {
  /// [ServiceResponseHandler] callbacks will be used to handle the different
  /// possible responses from the request
  Future<void> request({R requestModel});
}

abstract class ServiceResponseHandler<S extends ServiceResponseModel> {
  void onSuccess(S responseModel);
  void onNoConnectivity();
}
