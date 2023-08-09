import 'package:clean_framework_legacy/clean_framework.dart';

class ExampleEntity extends Entity {
  final DateTime lastLogin;
  final int loginCount;

  ExampleEntity({
    List<EntityFailure> errors = const [],
    DateTime? lastLogin,
    this.loginCount = 0,
  })  : lastLogin = lastLogin ?? DateTime.now(),
        super(errors: errors);

  @override
  List<Object> get props => [errors, lastLogin, loginCount];

  @override
  ExampleEntity merge({
    List<EntityFailure>? errors,
    DateTime? lastLogin,
    int? loginCount,
  }) {
    return ExampleEntity(
      errors: errors ?? this.errors,
      lastLogin: lastLogin ?? this.lastLogin,
      loginCount: loginCount ?? this.loginCount,
    );
  }
}
