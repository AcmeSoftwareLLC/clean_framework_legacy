import 'package:clean_framework_example/example_feature/ui/example_feature_widget.dart';
import 'package:clean_framework_example/payment/ui/payment_feature_widget.dart';
import 'package:flutter/material.dart';

///
class Routes {
  ///
  static const String example = '/';

  ///
  static const String payment = '/payment';

  ///
  static Widget generate(String routeName) {
    switch (routeName) {
      case example:
        return ExampleFeatureWidget();
      case payment:
        return PaymentFeatureWidget();
      default:
        return Scaffold(
          body: Center(
            child: Text('404, Page Not Found!'),
          ),
        );
    }
  }
}
