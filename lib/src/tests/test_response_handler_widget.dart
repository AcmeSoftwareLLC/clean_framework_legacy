import 'package:clean_framework_legacy/clean_framework.dart';
import 'package:flutter/material.dart';

class TestResponseHandlerWidget<B extends ErrorPublisherBloc>
    extends StatefulWidget {
  final Widget child;
  final Function(PublishedErrorType) onError;

  const TestResponseHandlerWidget(
      {Key? key, required this.onError, required this.child})
      : super(key: key);

  @override
  _TestResponseHandlerWidgetState<B> createState() =>
      _TestResponseHandlerWidgetState<B>();
}

class _TestResponseHandlerWidgetState<B extends ErrorPublisherBloc>
    extends State<TestResponseHandlerWidget<B>> {
  @override
  void initState() {
    super.initState();
    B bloc = BlocProvider.of<B>(context);
    bloc.errorPipe.receive.listen((PublishedErrorType errorType) {
      widget.onError(errorType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
