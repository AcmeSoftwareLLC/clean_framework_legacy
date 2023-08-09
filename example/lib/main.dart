import 'package:clean_framework_legacy/clean_framework.dart';
import 'package:clean_framework_example/providers.dart';
import 'package:clean_framework_example/routes.dart';
import 'package:flutter/material.dart';

import 'example_locator.dart';

void main() {
  logger().setLogLevel(LogLevel.verbose);

  runApp(_ExampleApp());
}

final providersContext = ProvidersContext();

class _ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppProvidersContainer(
      providersContext: providersContext,
      onBuild: (context, _) {
        providersContext().read(featureStatesProvider.featuresMap).load({
          'features': [
            {'name': 'example', 'state': 'ACTIVE'},
            {'name': 'payments', 'state': 'HIDDEN'},
          ]
        });
      },
      child: CFRouterScope(
        initialRoute: Routes.example,
        routeGenerator: Routes.generate,
        builder: (context) {
          return MaterialApp.router(
            routeInformationParser: CFRouteInformationParser(),
            routerDelegate: CFRouterDelegate(context),
          );
        },
      ),
    );
  }
}
