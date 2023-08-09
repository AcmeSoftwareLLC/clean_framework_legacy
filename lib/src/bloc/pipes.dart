// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'dart:ui';

import 'package:meta/meta.dart';

import 'bloc.dart';

/// A wrapper class around [Stream].
///
/// Prefer using [EventPipe] if no data is to be sent.
class Pipe<T> {
  /// Decides whether or not the same data can be sent over the [Pipe].
  final bool canSendDuplicateData;

  /// The initially feed data to the [Pipe].
  final T? initialData;
  final StreamController<T> _controller;

  bool _hasListeners = false;
  T? _lastData;

  /// The [Stream] that the [Pipe] holds.
  Stream<T> get receive => _controller.stream;

  /// Returns true if the [Pipe] has at least one listener.
  bool get hasListeners => _hasListeners;

  /// THe previous data that the [Pipe] held just before the present data.
  T? get previousData => _lastData;

  Pipe._({
    StreamController<T>? controller,
    this.initialData,
    this.canSendDuplicateData = false,
  }) : _controller = controller ?? StreamController<T>.broadcast() {
    _controller.onListen = () => _hasListeners = true;
  }

  /// Creates a [Pipe], where it is bound within the [bloc] provided.
  ///
  /// Using this constructor instead of regular one ensures that the pipes
  /// constructed will be automatically disposed by the bloc.
  Pipe.bloc(Bloc bloc, {T? initialData, bool canSendDuplicateData = false})
      : _controller = StreamController<T>.broadcast(),
        initialData = initialData,
        canSendDuplicateData = canSendDuplicateData {
    _controller.onListen = () => _hasListeners = true;
    bloc.pipes.add(this);
  }

  /// Creates a [Pipe].
  ///
  /// The pipe has broadcasting behavior .i.e can have multiple listeners.
  factory Pipe({T? initialData, bool canSendDuplicateData = false}) {
    return Pipe._(
      initialData: initialData,
      canSendDuplicateData: canSendDuplicateData,
    );
  }

  /// Creates a [Pipe], where it can only have a single listener.
  ///
  /// Prefer using this pipe when it is confident that it should only be listened from a single place.
  factory Pipe.single({T? initialData, bool canSendDuplicateData = false}) {
    return Pipe._(
      controller: StreamController<T>(),
      initialData: initialData,
      canSendDuplicateData: canSendDuplicateData,
    );
  }

  /// A callback that reports whenever the [Pipe] is listened.
  void whenListenedDo(VoidCallback onListen) {
    _controller.onListen = () {
      _hasListeners = true;
      onListen();
    };
  }

  /// Closes the underlying [Stream].
  ///
  /// This method must be called after the [Pipe]'s usage is done,
  /// otherwise it could cause memory leaks.
  void dispose() {
    _controller.close();
  }

  /// Sends the [data] to all the listeners of the [Pipe].
  bool send(T data) {
    if (_controller.isClosed || (!canSendDuplicateData && _lastData == data)) {
      return false;
    }
    _lastData = data;
    _controller.add(data);
    return true;
  }

  /// Throws [error] to all the listeners of the [Pipe].
  bool throwError(Object error) {
    if (_controller.isClosed) return false;
    _controller.addError(error);
    return true;
  }
}

/// A special kind of [Pipe] which can be used to send events instead of data.
///
/// Use [Pipe] instead, if data is to be sent alongside.
class EventPipe extends Pipe<void> {
  /// Creates an [EventPipe].
  EventPipe() : super._(initialData: null, canSendDuplicateData: true);

  /// Creates an [EventPipe], where it is bound within the [bloc] provided.
  EventPipe.bloc(Bloc bloc) : super.bloc(bloc, canSendDuplicateData: true);

  @override
  @visibleForTesting
  Stream<void> get receive {
    throw StateError(
      "EventPipe isn't intended for receiving data. Use Pipe instead.",
    );
  }

  @override
  @visibleForTesting
  bool send(_) {
    if (_controller.isClosed) return false;
    _controller.add(null);
    return true;
  }

  /// Launches an event.
  bool launch() => send(null);

  /// Adds a subscription to this pipe.
  StreamSubscription<void> listen(void onData(), {Function? onError}) {
    return _controller.stream.listen((_) => onData(), onError: onError);
  }
}
