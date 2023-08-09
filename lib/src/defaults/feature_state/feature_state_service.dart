import 'package:clean_framework_legacy/clean_framework.dart';
import 'package:clean_framework_legacy/clean_framework_defaults.dart';

/// When the JSON required to create the feature states map comes from
/// a simple REST service, this class can be used to transform the
/// response data into the map required by the [FeatureMapper] inside
/// a [FeatureStateProvider]
class FeatureStateService
    extends EitherService<JsonRequestModel, EmptyJsonResponseModel> {
  final FeatureMapper _featuresMap;
  FeatureStateService(
      {required RestApi restApi, required FeatureMapper featuresMap})
      : _featuresMap = featuresMap,
        super(method: RestMethod.get, restApi: restApi, path: 'feature-states');

  @override
  parseResponse(Map<String, dynamic> jsonResponse) {
    _featuresMap.load(jsonResponse);
    return EmptyJsonResponseModel();
  }
}
