import 'package:clean_framework_legacy/clean_framework.dart';
import 'package:clean_framework_example/payment/model/payment_view_model.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends Screen {
  final PaymentViewModel viewModel;
  final Function onChangeFromAccount;
  final Function onChangeToAccount;
  final Function onChangeAmount;
  final VoidCallback onTapSubmit;

  PaymentScreen({
    required this.viewModel,
    required this.onChangeFromAccount,
    required this.onChangeToAccount,
    required this.onChangeAmount,
    required this.onTapSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _TextFieldListTile(
              type: 'text',
              textTitle: 'From Account',
              text: viewModel.fromAccount,
              onChangeTextField: (value) {
                onChangeFromAccount(value);
              },
            ),
            _TextFieldListTile(
              type: 'text',
              textTitle: 'To Account',
              text: viewModel.toAccount,
              onChangeTextField: (value) {
                onChangeToAccount(value);
              },
            ),
            _TextFieldListTile(
              type: 'amount',
              textTitle: 'Amount',
              text: viewModel.amount.toString(),
              onChangeTextField: (value) {
                onChangeAmount(value);
              },
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
              child: ElevatedButton(
                child: Text('Submit'),
                onPressed: onTapSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextFieldListTile extends ListTile {
  final String textTitle;
  final String type;
  final String text;
  final Function onChangeTextField;

  _TextFieldListTile({
    required this.textTitle,
    required this.type,
    required this.text,
    required this.onChangeTextField,
  });

  Widget _buildContentField(BuildContext context) {
    final textController = TextEditingController();
    textController.text = text;
    textController.selection = TextSelection.fromPosition(
        TextPosition(offset: textController.text.length));
    return Container(
      child: TextField(
        controller: textController,
        keyboardType: (type == 'amount')
            ? TextInputType.numberWithOptions(signed: false, decimal: true)
            : TextInputType.number,
        enableInteractiveSelection: false,
        onChanged: (value) {
          onChangeTextField(value);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Text(
                    textTitle,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(child: _buildContentField(context)),
              )
            ],
          ),
        ),
      ],
    );
  }
}
