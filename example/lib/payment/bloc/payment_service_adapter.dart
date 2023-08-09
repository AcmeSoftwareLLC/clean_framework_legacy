import 'package:clean_framework_legacy/clean_framework.dart';
import 'package:clean_framework_example/payment/api/payment_service.dart';
import 'package:clean_framework_example/payment/api/payment_service_request_model.dart';
import 'package:clean_framework_example/payment/api/payment_service_response_model.dart';
import 'package:clean_framework_example/payment/model/payment_entity.dart';

class PaymentServiceAdapter extends ServiceAdapter<PaymentEntity,
    PaymentServiceRequestModel, PaymentServiceResponseModel, PaymentService> {
  PaymentServiceAdapter() : super(PaymentService());

  @override
  PaymentEntity createEntity(
      PaymentEntity initialEntity, PaymentServiceResponseModel responseModel) {
    return initialEntity.merge(errors: <EntityFailure>[]);
  }

  @override
  PaymentServiceRequestModel createRequest(PaymentEntity entity) {
    return PaymentServiceRequestModel(
        fromAccount: entity.fromAccount,
        toAccount: entity.toAccount,
        amount: entity.amount);
  }
}
