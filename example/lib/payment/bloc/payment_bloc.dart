import 'package:clean_framework_legacy/clean_framework.dart';
import 'package:clean_framework_example/payment/bloc/payment_usecase.dart';
import 'package:clean_framework_example/payment/model/payment_view_model.dart';

class PaymentBloc extends Bloc with ViewModelBlocMixin<PaymentViewModel> {
  late final PaymentUseCase _paymentUseCase;

  late final Pipe<double> amountPipe;
  late final Pipe<String> fromAccountPipe;
  late final Pipe<String> toAccountPipe;
  late final EventPipe submitPipe;

  @override
  void onViewAttached() {
    _paymentUseCase.create();
  }

  PaymentBloc() {
    _paymentUseCase = PaymentUseCase(viewModelPipe.send);
    amountPipe = Pipe.bloc(this)..receive.listen(amountInputHandler);
    fromAccountPipe = Pipe.bloc(this)..receive.listen(fromAccountInputHandler);
    toAccountPipe = Pipe.bloc(this)..receive.listen(toAccountInputHandler);
    submitPipe = EventPipe.bloc(this)..listen(submitHandler);
  }

  void amountInputHandler(double amount) {
    _paymentUseCase.updateAmount(amount);
  }

  void fromAccountInputHandler(String accountId) {
    _paymentUseCase.updateFromAccount(accountId);
  }

  void toAccountInputHandler(String accountId) {
    _paymentUseCase.updateToAccount(accountId);
  }

  void submitHandler() {
    _paymentUseCase.submit();
  }
}
