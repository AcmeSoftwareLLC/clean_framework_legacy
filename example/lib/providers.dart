import 'package:clean_framework_legacy/clean_framework.dart';
import 'package:clean_framework_example/features.dart';

final featureStatesProvider =
    FeatureStateProvider<FeatureState, ExampleFeatureMapper>(
        (_) => ExampleFeatureMapper());
