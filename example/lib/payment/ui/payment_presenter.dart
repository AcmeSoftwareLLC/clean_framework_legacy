import 'package:clean_framework_legacy/clean_framework.dart';
import 'package:clean_framework_example/payment/bloc/payment_bloc.dart';
import 'package:clean_framework_example/payment/model/payment_view_model.dart';
import 'package:clean_framework_example/payment/ui/payment_screen.dart';
import 'package:flutter/material.dart';

class PaymentPresenter
    extends Presenter<PaymentBloc, PaymentViewModel, PaymentScreen> {
  @override
  PaymentScreen buildScreen(
    BuildContext context,
    PaymentBloc bloc,
    PaymentViewModel viewModel,
  ) {
    return PaymentScreen(
      viewModel: viewModel,
      onChangeFromAccount: (value) {
        _onChangeFromAccount(value, bloc);
      },
      onChangeToAccount: (value) {
        _onChangeToAccount(value, bloc);
      },
      onChangeAmount: (value) {
        _onChangeAmount(value, bloc);
      },
      onTapSubmit: () {
        _onTapSubmit(bloc);
      },
    );
  }

  @override
  Widget buildLoadingScreen(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  void onViewModelUpdate(
    BuildContext context,
    PaymentBloc bloc,
    PaymentViewModel viewModel,
  ) {
    if (viewModel.serviceStatus == ServiceStatus.successful) {
      _navigateToDetailScreen(context);
    } else if (viewModel.serviceStatus == ServiceStatus.failed) {
      _showErrorDialog(context);
    } else if (viewModel.dataStatus == DataStatus.invalid) {
      _showInvalidDataDialog(context);
    }
  }

  void _onChangeFromAccount(String text, PaymentBloc bloc) {
    bloc.fromAccountPipe.send(text);
  }

  void _onChangeToAccount(String text, PaymentBloc bloc) {
    bloc.toAccountPipe.send(text);
  }

  void _onChangeAmount(String value, PaymentBloc bloc) {
    final amount = double.tryParse(value);
    if (amount != null) {
      bloc.amountPipe.send(amount);
    }
  }

  void _onTapSubmit(PaymentBloc bloc) {
    bloc.submitPipe.launch();
  }

  void _navigateToDetailScreen(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Success'),
        content: Text('Submit Succeeded'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              context.router.reset();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Error'),
        content: Text('Submit Failed'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showInvalidDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Invalid'),
        content: Text('Data entered is incorrect.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
