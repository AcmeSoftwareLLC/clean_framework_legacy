import 'package:clean_framework_legacy/clean_framework.dart';

class ExampleViewModel extends ViewModel {
  final DateTime lastLogin;
  final int loginCount;

  ExampleViewModel({required this.lastLogin, required this.loginCount});

  @override
  List<Object> get props => [lastLogin, loginCount];
}
