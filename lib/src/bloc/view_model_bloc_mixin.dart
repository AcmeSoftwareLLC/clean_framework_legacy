import 'package:clean_framework_legacy/clean_framework.dart';
import 'package:meta/meta.dart';

/// A mixin to [Bloc] that attaches a [Pipe] for sending [ViewModel] to the bloc.
mixin ViewModelBlocMixin<V extends ViewModel> on Bloc {
  /// The ViewModel Pipe.
  late final Pipe<V> viewModelPipe = Pipe.bloc(this)
    ..whenListenedDo(onViewAttached);

  /// Called whenever the the [Bloc] is attached to the view .i.e [Presenter].
  @protected
  void onViewAttached();
}
