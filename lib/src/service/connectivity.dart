import 'package:clean_framework_legacy/clean_framework.dart';

enum ConnectivityStatus { online, offline }

typedef ConnectivityListener = void Function(ConnectivityStatus status);

abstract class Connectivity extends ExternalDependency {
  Future<ConnectivityStatus> getConnectivityStatus();
  void registerConnectivityChangeListener(ConnectivityListener listener);
}
