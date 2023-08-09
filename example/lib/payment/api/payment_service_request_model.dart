import 'package:clean_framework_legacy/clean_framework_defaults.dart';
import 'package:equatable/equatable.dart';

class PaymentServiceRequestModel extends Equatable implements JsonRequestModel {
  final String fromAccount;
  final String toAccount;
  final double amount;

  PaymentServiceRequestModel({
    required this.amount,
    required this.fromAccount,
    required this.toAccount,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'fromAccount': fromAccount,
      'toAccount': toAccount,
      'amount': amount.toString(),
    };
  }

  @override
  List<Object> get props => [fromAccount, toAccount, amount];
}
