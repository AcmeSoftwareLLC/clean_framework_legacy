import 'package:clean_framework_legacy/clean_framework.dart';
import 'package:clean_framework_example/payment/bloc/payment_bloc.dart';
import 'package:clean_framework_example/payment/ui/payment_presenter.dart';
import 'package:flutter/material.dart';

class PaymentFeatureWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentBloc(),
      child: PaymentPresenter(),
    );
  }
}
