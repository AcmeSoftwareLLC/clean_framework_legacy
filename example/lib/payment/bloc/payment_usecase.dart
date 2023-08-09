import 'package:clean_framework_legacy/clean_framework.dart';
import 'package:clean_framework_legacy/clean_framework_defaults.dart';
import 'package:clean_framework_example/example_locator.dart';
import 'package:clean_framework_example/payment/bloc/payment_service_adapter.dart';
import 'package:clean_framework_example/payment/model/payment_entity.dart';
import 'package:clean_framework_example/payment/model/payment_view_model.dart';

/// UseCase is a declarative chain of pure functions (instruction or command).
/// Commands are async functions that return an Either or Maybe.
/// The commands will receive the state and create new states.
///   a) Developers cannot change state when it is not allowed.
///   b) History of changes.
/// Bloc events will launch UseCases, while listening to publications from the UseCase that
///   returns a ViewModel, which is pushed down to the Presenter.

class PaymentUseCase extends UseCase {
  late final ViewModelCallback<PaymentViewModel> _viewModelCallBack;

  late RepositoryScope _scope;

  PaymentUseCase(ViewModelCallback<PaymentViewModel> viewModelCallBack)
      : _viewModelCallBack = viewModelCallBack;

  void create() async {
    var scope = ExampleLocator().repository.containsScope<PaymentEntity>();
    if (scope == null) {
      final newPaymentEntity = PaymentEntity();
      scope = ExampleLocator()
          .repository
          .create<PaymentEntity>(newPaymentEntity, _notifySubscribers);
    } else {
      scope.subscription = _notifySubscribers;
    }
    _scope = scope;
    final entity = ExampleLocator().repository.get<PaymentEntity>(_scope);
    _viewModelCallBack(buildViewModelForLocalUpdate(entity));
  }

  void updateAmount(double amount) async {
    final entity = ExampleLocator().repository.get<PaymentEntity>(_scope);

    final updatedEntity = entity.merge(amount: amount);
    ExampleLocator().repository.update<PaymentEntity>(_scope, updatedEntity);
    _viewModelCallBack(buildViewModelForLocalUpdate(updatedEntity));
  }

  void updateFromAccount(String accountId) async {
    final entity = ExampleLocator().repository.get<PaymentEntity>(_scope);

    final updatedEntity = entity.merge(fromAccount: accountId);
    ExampleLocator().repository.update<PaymentEntity>(_scope, updatedEntity);
    _viewModelCallBack(buildViewModelForLocalUpdate(updatedEntity));
  }

  void updateToAccount(String accountId) async {
    final entity = ExampleLocator().repository.get<PaymentEntity>(_scope);

    final updatedEntity = entity.merge(toAccount: accountId);
    ExampleLocator().repository.update<PaymentEntity>(_scope, updatedEntity);
    _viewModelCallBack(buildViewModelForLocalUpdate(updatedEntity));
  }

  void submit() async {
    final entity = ExampleLocator().repository.get<PaymentEntity>(_scope);
    if (entity.fromAccount == '' ||
        entity.toAccount == '' ||
        entity.amount == 0.0) {
      _viewModelCallBack(buildViewModelForLocalUpdateWithError(entity));
    } else {
      await ExampleLocator()
          .repository
          .runServiceAdapter(_scope, PaymentServiceAdapter());
    }
  }

  void _notifySubscribers(entity) {
    _viewModelCallBack(buildViewModelForServiceUpdate(entity));
  }

  PaymentViewModel buildViewModelForServiceUpdate(PaymentEntity entity) {
    if (entity.hasErrors()) {
      return PaymentViewModel(
          fromAccount: entity.fromAccount,
          toAccount: entity.toAccount,
          amount: entity.amount,
          serviceStatus: ServiceStatus.failed);
    } else {
      return PaymentViewModel(
          fromAccount: entity.fromAccount,
          toAccount: entity.toAccount,
          amount: entity.amount,
          serviceStatus: ServiceStatus.successful);
    }
  }

  PaymentViewModel buildViewModelForLocalUpdate(PaymentEntity entity) {
    return PaymentViewModel(
        fromAccount: entity.fromAccount,
        toAccount: entity.toAccount,
        amount: entity.amount);
  }

  PaymentViewModel buildViewModelForLocalUpdateWithError(PaymentEntity entity) {
    return PaymentViewModel(
        fromAccount: entity.fromAccount,
        toAccount: entity.toAccount,
        amount: entity.amount,
        dataStatus: DataStatus.invalid);
  }
}
