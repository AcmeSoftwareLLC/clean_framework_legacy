import 'package:clean_framework_legacy/clean_framework.dart';
import 'package:clean_framework_legacy/clean_framework_defaults.dart';
import 'package:clean_framework_example/example_feature/api/example_service.dart';
import 'package:clean_framework_example/example_feature/api/example_service_response_model.dart';
import 'package:clean_framework_example/example_feature/model/example_entity.dart';

class ExampleServiceAdapter extends ServiceAdapter<ExampleEntity,
    JsonRequestModel, ExampleServiceResponseModel, ExampleService> {
  ExampleServiceAdapter() : super(ExampleService());

  @override
  ExampleEntity createEntity(
      ExampleEntity initialEntity, ExampleServiceResponseModel responseModel) {
    return initialEntity.merge(
      loginCount: responseModel.loginCount,
      lastLogin: DateTime.tryParse(responseModel.lastLogin),
    );
  }
}
