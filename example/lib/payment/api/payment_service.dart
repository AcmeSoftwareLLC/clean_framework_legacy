import 'package:clean_framework_legacy/clean_framework.dart';
import 'package:clean_framework_legacy/clean_framework_defaults.dart';
import 'package:clean_framework_example/example_locator.dart';
import 'package:clean_framework_example/payment/api/payment_service_request_model.dart';
import 'package:clean_framework_example/payment/api/payment_service_response_model.dart';

class PaymentService extends EitherService<PaymentServiceRequestModel,
    PaymentServiceResponseModel> {
  PaymentService()
      : super(
            method: RestMethod.post,
            restApi: ExampleLocator().api,
            path: 'make-payment');

  @override
  PaymentServiceResponseModel parseResponse(Map<String, dynamic> jsonResponse) {
    return PaymentServiceResponseModel.fromJson(jsonResponse);
  }
}
