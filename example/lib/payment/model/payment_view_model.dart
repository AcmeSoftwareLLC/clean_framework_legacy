import 'package:clean_framework_legacy/clean_framework.dart';

enum ServiceStatus { failed, successful, unknown }

enum DataStatus { valid, invalid, unknown }

class PaymentViewModel extends ViewModel {
  final String fromAccount;
  final String toAccount;
  final double amount;
  final serviceStatus;
  final dataStatus;

  PaymentViewModel({
    required this.fromAccount,
    required this.toAccount,
    required this.amount,
    this.serviceStatus = ServiceStatus.unknown,
    this.dataStatus = DataStatus.unknown,
  });

  @override
  List<Object> get props =>
      [fromAccount, toAccount, amount, serviceStatus, dataStatus];
}
