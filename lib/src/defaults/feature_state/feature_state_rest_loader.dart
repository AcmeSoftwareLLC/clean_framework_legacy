import 'package:clean_framework_legacy/clean_framework.dart';
import 'package:clean_framework_legacy/clean_framework_defaults.dart';

/// This helper class uses an instance of [FeatureStateService] to
/// update the feature states map in an existing [FeatureStateProvider]
class FeatureStateRestLoader<S, M extends FeatureMapper<S>,
    P extends FeatureStateProvider<S, M>, E extends EitherService> {
  final E _service;
  Function(ServiceFailure) _onServiceFailure;

  FeatureStateRestLoader(
      {required E service, required Function(ServiceFailure) onServiceFailure})
      : _service = service,
        _onServiceFailure = onServiceFailure;

  Future<void> fetchInitialData() async {
    final Either eitherResponse = await _service.request();
    eitherResponse.fold(
      (error) => _onServiceFailure(error),
      (_) => null,
    );
  }
}
