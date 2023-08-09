import 'package:clean_framework_legacy/clean_framework_defaults.dart';

class PaymentServiceResponseModel extends JsonResponseModel {
  final bool didSucceed;

  PaymentServiceResponseModel.fromJson(Map<String, dynamic> json)
      : didSucceed = true;

  @override
  List<Object> get props => [didSucceed];
}
