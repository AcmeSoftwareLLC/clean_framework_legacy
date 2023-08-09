import 'package:clean_framework_legacy/clean_framework_defaults.dart';

class ExampleServiceResponseModel extends JsonResponseModel {
  final String lastLogin;
  final int loginCount;

  ExampleServiceResponseModel.fromJson(Map<String, dynamic> json)
      : lastLogin = json['lastLogin'] ?? '',
        loginCount = json['loginCount'] ?? 0;

  @override
  List<Object> get props => [lastLogin, loginCount];
}
