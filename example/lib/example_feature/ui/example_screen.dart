import 'package:clean_framework_legacy/clean_framework.dart';
import 'package:clean_framework_example/example_feature/model/example_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExampleScreen extends Screen {
  final ExampleViewModel viewModel;
  final VoidCallback navigateToMakePayment;

  ExampleScreen({required this.viewModel, required this.navigateToMakePayment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 200,
          child: Card(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text('Last Login'),
                  subtitle: Text(
                    DateFormat('yyyy-MM-dd').format(viewModel.lastLogin),
                  ),
                ),
                ListTile(
                  title: Text('Login Count'),
                  subtitle: Text(viewModel.loginCount.toString()),
                ),
                ElevatedButton(
                  child: Text('Make Payment'),
                  onPressed: () {
                    navigateToMakePayment();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
