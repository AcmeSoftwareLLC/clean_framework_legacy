import 'package:clean_framework_legacy/src/model/view_model.dart';

typedef ViewModelCallback<T extends ViewModel> = bool Function(T);

abstract class UseCase {}
