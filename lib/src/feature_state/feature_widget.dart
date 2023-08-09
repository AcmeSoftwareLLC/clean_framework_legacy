import 'package:clean_framework_legacy/src/feature_state/feature_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'feature.dart';

/// For each feature entry point, a FeatureWidget instance is used to control
/// the visibility and behavior of the children. One FeatureWidget could have
/// many UI widgets, one per each state.
///
/// The S on the generics declaration stands for the class that is going to use
/// to determine the possible value for a given state. The most common data
/// type used here is an enum. You are free to use anything that provides a
/// similar behavior.
///
/// The objects of this class need an existing Feature object and a
/// FeatureProvider object. The provider is used internally to extract the
/// current state for the given Feature, and use it as part of the [builder]
/// method.
abstract class FeatureWidget<S> extends ConsumerWidget {
  final StateNotifierProvider<FeatureMapper<S>, Map<Feature, S>> provider;
  final Feature feature;

  FeatureWidget({
    Key? key,
    required this.provider,
    required this.feature,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(provider);
    final featureStates = ref.watch(provider.notifier);
    final currentState = featureStates.getStateFor(feature);

    return builder(context, currentState);
  }

  /// The override of this method should return the proper widget depending
  /// on the currentState value. A common pattern is to have states that
  /// instead of returning a visible widget, return an empty container.
  ///
  /// The developer can use [HiddenWidget] to return a simple empty container
  /// with a key that can by checked during tests.
  Widget builder(BuildContext context, S currentState);
}
