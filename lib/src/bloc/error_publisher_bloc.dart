import 'package:clean_framework_legacy/clean_framework.dart';

abstract class ErrorPublisherBloc extends Bloc {
  static final String noListenersError = r'Response Handler has no listeners';

  final Pipe<PublishedErrorType> errorPipe = Pipe<PublishedErrorType>();

  void handleError(PublishedErrorType errorType) {
    if (!errorPipe.hasListeners)
      throw StateError(noListenersError);
    else
      errorPipe.send(errorType);
  }

  @override
  void dispose() {
    errorPipe.dispose();
    super.dispose();
  }
}

enum PublishedErrorType {
  general,
  noConnectivity,
}
