import 'dart:async';

import 'package:clean_framework_legacy/clean_framework.dart';
import 'package:clean_framework_example/example_feature/bloc/example_bloc.dart';
import 'package:clean_framework_example/routes.dart';
import 'package:flutter/material.dart';

import 'example_screen.dart';

/// CHALLENGUES:
/// 1) Errors that should show a dialog have not been covered by guidelines.
///   The main problem is that dialogs should be shown only once, but the
///   ViewModels have flags that tells the presenter to show errors. To ensure
///   that only they are shown once, probably the Presenter should be a
///   Stateful Widget, and absorb the error logic, similar to how we handle
///   navigation with RouterWidget
/// 2) Validation of data is also not covered in guidelines. Our forms
///   are handler by business logic in the feature. Sometimes it is fully
///   done by the bloc, but there are currently issues when dealing with Text
///   Controllers.

class ExamplePresenter
    extends Presenter<ExampleBloc, ExampleViewModel, ExampleScreen> {
  @override
  Stream<ExampleViewModel> getViewModelStream(ExampleBloc bloc) {
    return bloc.exampleViewModelPipe.receive;
  }

  @override
  ExampleScreen buildScreen(
    BuildContext context,
    ExampleBloc bloc,
    ExampleViewModel viewModel,
  ) {
    return ExampleScreen(
      viewModel: viewModel,
      navigateToMakePayment: () {
        context.router.push(Routes.payment);
      },
    );
  }
}
