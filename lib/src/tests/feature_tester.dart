import 'package:clean_framework_legacy/clean_framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FeatureTester<S> {
  final _container = ProviderContainer();
  final FeatureStateProvider _featureStateProvider;

  FeatureTester(this._featureStateProvider);

  Future<void> pumpWidget(WidgetTester tester, Widget widget) =>
      tester.pumpWidget(
          UncontrolledProviderScope(container: _container, child: widget));

  void dispose() => _container.dispose();

  FeatureMapper<S> get featuresMap =>
      _container.read(_featureStateProvider.featuresMap);
}
