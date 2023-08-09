import 'dart:async';

import 'package:clean_framework_legacy/clean_framework.dart';
import 'package:flutter_test/flutter_test.dart';

class ViewModelPipeTester<V extends ViewModel> {
  Function? _launch;
  final Pipe<V> _publisher;
  Completer<void>? completer;
  bool hasInitialViewModelBeenReceived = false;
  V? receivedViewModel;
  late StreamSubscription _pipeSubscription;

  ViewModelPipeTester._(Pipe<V> publisher) : _publisher = publisher {
    _pipeSubscription = _publisher.receive.listen((output) {
      receivedViewModel = output;
      completer?.complete();

      hasInitialViewModelBeenReceived = true;
    });
  }

  static ViewModelPipeTester forPipe<V extends ViewModel>(Pipe<V> publisher) {
    return ViewModelPipeTester._(publisher);
  }

  ViewModelPipeTester whenBeingListenedTo() {
    // This empty step exists to make the test code more verbose
    if (hasInitialViewModelBeenReceived) {
      throw InitialViewModelAlreadySentPipeTesterError();
    }
    return this;
  }

  ViewModelPipeTester whenDoing(Function launch) {
    _launch = launch;
    return this;
  }

  /// Returns true when the model had to be completed.
  Future<bool> _waitForInitialModelIfNeeded() async {
    if (hasInitialViewModelBeenReceived) return false;
    completer = Completer<void>();
    await completer!.future.timeout(
      const Duration(seconds: 3),
      onTimeout: () => throw NeverReceivedInitialViewModelPipeTesterError(),
    );
    return true;
  }

  Future<void> _launchAction() async {
    if (_launch == null) return;
    completer = Completer<void>();
    _launch!();
    await completer!.future.timeout(
      const Duration(seconds: 3),
      onTimeout: () => throw NeverReceivedUpdatedViewModelPipeTesterError(),
    );
  }

  Future<void> thenExpectAnyModel() async {
    await _waitForInitialModelIfNeeded();
    await _launchAction();
  }

  Future<void> thenExpectA(V item) async {
    await thenExpectAnyModel();
    expect(receivedViewModel, item);
  }

  Future<void> thenExpectInOrder(List<V> items) async {
    assert(_launch != null);
    await _waitForInitialModelIfNeeded();
    _launch?.call();

    // forEach is asynchronous in Dart, this is to force it to be synchronous
    for (final item in items) {
      completer = Completer<void>();
      await completer!.future.timeout(
        const Duration(seconds: 3),
        onTimeout: () => throw NeverReceivedUpdatedViewModelPipeTesterError(),
      );
      expect(receivedViewModel, item);
    }
  }

  void dispose() {
    _pipeSubscription.cancel();
    completer?.complete();
  }
}

class NeverReceivedInitialViewModelPipeTesterError extends StateError {
  NeverReceivedInitialViewModelPipeTesterError()
      : super('Test failed: view model pipe never received the initial model');
}

class NeverReceivedUpdatedViewModelPipeTesterError extends StateError {
  NeverReceivedUpdatedViewModelPipeTesterError()
      : super('Test failed: view model pipe never received the updated model');
}

class InitialViewModelAlreadySentPipeTesterError extends StateError {
  InitialViewModelAlreadySentPipeTesterError()
      : super('Test failed: view model pipe already sent an initial model');
}

class NeverReceivedPipeTesterError extends StateError {
  NeverReceivedPipeTesterError(dynamic item)
      : super('Test failed: pipe never received a ${item.toString()}');
}

class MissingListenedCallbackPipeTesterError
    extends NeverReceivedPipeTesterError {
  MissingListenedCallbackPipeTesterError()
      : super(
            'ViewModelPipeTester can only be used with pipes that implement the method whenListenedDo.');
}
