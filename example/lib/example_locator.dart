import 'package:clean_framework_legacy/clean_framework.dart';
import 'package:clean_framework_legacy/clean_framework_defaults.dart';

ExampleLocator locator() => ExampleLocator();

Logger logger() => ExampleLocator().logger;

class ExampleLocator implements Locator {
  ExampleLocator._();

  factory ExampleLocator() {
    Locator.init(ExampleLocator._());
    return Locator.getInstance();
  }

  @override
  Connectivity connectivity = AlwaysOnlineConnectivity();

  @override
  Logger logger = ConsoleLogger(LogLevel.nothing);
  SimpleRestApi api = SimpleRestApi();

  Repository repository = Repository();

  void dispose() => Locator.dispose();
}
