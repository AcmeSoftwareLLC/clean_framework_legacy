import 'package:clean_framework_legacy/clean_framework.dart';

class PaymentEntity extends Entity {
  final String fromAccount;
  final String toAccount;
  final double amount;

  PaymentEntity({
    List<EntityFailure> errors = const [],
    this.fromAccount = '',
    this.toAccount = '',
    this.amount = 0.0,
  }) : super(errors: errors);

  @override
  List<Object> get props => [errors, fromAccount, toAccount, amount];

  @override
  PaymentEntity merge({
    List<EntityFailure>? errors,
    String? fromAccount,
    String? toAccount,
    double? amount,
  }) {
    return PaymentEntity(
      errors: errors ?? this.errors,
      fromAccount: fromAccount ?? this.fromAccount,
      toAccount: toAccount ?? this.toAccount,
      amount: amount ?? this.amount,
    );
  }
}
