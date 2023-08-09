import 'package:clean_framework_legacy/clean_framework.dart';
import 'package:clean_framework_example/example_feature/bloc/example_usecase.dart';
import 'package:clean_framework_example/example_feature/model/example_view_model.dart';

export 'package:clean_framework_example/example_feature/model/example_view_model.dart';

class ExampleBloc extends Bloc {
  late final ExampleUseCase _useCase;

  final exampleViewModelPipe = Pipe<ExampleViewModel>();

  @override
  void dispose() {
    exampleViewModelPipe.dispose();
    super.dispose();
  }

  ExampleBloc() {
    _useCase = ExampleUseCase(exampleViewModelPipe.send);
    exampleViewModelPipe.whenListenedDo(_useCase.execute);
  }
}
