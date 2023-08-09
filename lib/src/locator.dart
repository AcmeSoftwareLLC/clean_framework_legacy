import 'package:clean_framework_legacy/clean_framework.dart';
import 'package:clean_framework_legacy/clean_framework_defaults.dart';

class Locator {
  static Locator? _instance;

  static init(Locator locator) => _instance ??= locator;

  static T getInstance<T extends Locator>() {
    assert(_instance != null, "$T hasn't been initialized.");
    return _instance as T;
  }

  static void dispose() => _instance = null;

  Locator._();

  factory Locator() => _instance ??= Locator._();

  Logger logger = ConsoleLogger();

  Connectivity connectivity = AlwaysOnlineConnectivity();
}
