import 'package:clean_framework_legacy/clean_framework.dart';
import 'package:clean_framework_example/example_feature/bloc/example_service_adapter.dart';
import 'package:clean_framework_example/example_feature/model/example_entity.dart';
import 'package:clean_framework_example/example_feature/model/example_view_model.dart';
import 'package:clean_framework_example/example_locator.dart';

/// UseCase is a declarative chain of pure functions (instruction or command).
/// Commands are async functions that return an Either or Maybe.
/// The commands will receive the state and create new states.
///   a) Developers cannot change state when it is not allowed.
///   b) History of changes.
/// Bloc events will launch UseCases, while listening to publications from the UseCase that
///   returns a ViewModel, which is pushed down to the Presenter.

class ExampleUseCase extends UseCase {
  late final ViewModelCallback<ExampleViewModel> _viewModelCallBack;

  ExampleUseCase(ViewModelCallback<ExampleViewModel> viewModelCallBack)
      : _viewModelCallBack = viewModelCallBack;

  void execute() async {
    final scope = ExampleLocator()
        .repository
        .create<ExampleEntity>(ExampleEntity(), _notifySubscribers);

    await ExampleLocator()
        .repository
        .runServiceAdapter(scope, ExampleServiceAdapter());
  }

  void _notifySubscribers(entity) {
    _viewModelCallBack(buildViewModel(entity));
  }

  ExampleViewModel buildViewModel(ExampleEntity entity) {
    return ExampleViewModel(
      lastLogin: entity.lastLogin,
      loginCount: entity.loginCount,
    );
  }
}
