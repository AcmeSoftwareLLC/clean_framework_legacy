import 'package:clean_framework_legacy/clean_framework.dart';
import 'package:clean_framework_example/example_feature/bloc/example_bloc.dart';
import 'package:flutter/material.dart';

import '../../features.dart';
import '../../providers.dart';
import '../../widgets.dart';
import 'example_presenter.dart';

class ExampleFeatureWidget extends FeatureWidget<FeatureState> {
  ExampleFeatureWidget()
      : super(
          feature: exampleFeature,
          provider: featureStatesProvider(),
        );
  @override
  Widget builder(BuildContext context, FeatureState currentState) {
    switch (currentState) {
      case FeatureState.active:
        return BlocProvider<ExampleBloc>(
          create: (_) => ExampleBloc(),
          child: ExamplePresenter(),
        );
      default:
        return HiddenFeature();
    }
  }
}
