import 'dart:async';

import 'package:clean_framework_legacy/clean_framework.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

abstract class Presenter<B extends Bloc, V extends ViewModel, S extends Screen>
    extends StatefulWidget {
  @override
  @nonVirtual
  _PresenterState<B, V, S> createState() => _PresenterState<B, V, S>();

  Stream<V> getViewModelStream(B bloc) {
    if (bloc is ViewModelBlocMixin<V>) return bloc.viewModelPipe.receive;

    throw Exception(
      "Must override `getViewModelStream`, if the bloc doesn't use `ViewModelBlocMixin`.",
    );
  }

  /// Builds the screen.
  S buildScreen(BuildContext context, B bloc, V viewModel);

  /// Builds the loading screen.
  Widget buildLoadingScreen(BuildContext context) {
    return SizedBox.shrink(key: Key('waitingForStream'));
  }

  /// Builds the error screen.
  Widget buildErrorScreen(BuildContext context, Object? error) {
    return SizedBox.shrink(key: Key('noContentFromStream'));
  }

  /// By default, the view model pipe should have a onListen callback on the
  /// bloc, causing to be unnecessary to create an event to retrieve it. If the
  /// view model is generated by a complex logic, this method can be overridden
  /// to call an specific event.
  void sendViewModelRequest(B bloc) {}

  /// Called whenever the [viewModel] is updated.
  void onViewModelUpdate(BuildContext context, B bloc, V viewModel) {}
}

class _PresenterState<B extends Bloc, V extends ViewModel, S extends Screen>
    extends State<Presenter<B, V, S>> {
  late B _bloc;
  Widget? _child;
  StreamSubscription<V>? _subscription;

  @override
  void initState() {
    super.initState();
    _bloc = context.bloc<B>();
    _subscribe();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => widget.sendViewModelRequest(_bloc),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _child ?? widget.buildLoadingScreen(context);
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    widget.getViewModelStream(_bloc).listen(
      (viewModel) {
        widget.onViewModelUpdate(context, _bloc, viewModel);
        _child = widget.buildScreen(context, _bloc, viewModel);
        setState(() {});
      },
      onError: (error, stackTrace) {
        _child = widget.buildErrorScreen(context, error);
        setState(() {});
      },
    );
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }
}
