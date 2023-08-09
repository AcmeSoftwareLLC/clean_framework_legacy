import 'package:meta/meta.dart';

import 'pipes.dart';

/// A class that represents the logic of data flow within the application.
/// It is the middle layer between the API and UI layers.
/// The Bloc is responsible for updating the pipe when the data changes.
abstract class Bloc {
  /// Holds all the [Pipe]s that is attached to the [Bloc] using [Pipe.bloc] constructor.
  @visibleForTesting
  final Set<Pipe> pipes = {};

  /// All [Pipe]s that are created under the [Bloc] must be disposed here.
  ///
  /// Bloc is generally instantiated by some part of UI, where the same UI must call [dispose],
  /// otherwise it may lead to memory leaks.
  @mustCallSuper
  void dispose() {
    for (final pipe in pipes) {
      pipe.dispose();
    }
  }
}
