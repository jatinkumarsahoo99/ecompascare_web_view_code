import 'package:connectivity_plus/connectivity_plus.dart';

abstract class IInternetConnectionManager {
  ///This will always tell that whether the app is connected to internet or not
  bool get isInternetConnected;

  ///Need to initialize on app open i.e, in the main method
  void initialize();

  ///This will be a listener which will listen to internet connectivity
  ///this will only tell you whether you are connected to a internet or not
  void listener(
    void Function(bool) onConnection, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  });

  ///This will be a listener which will listen to internet connectivity
  ///this will also tell whether you are connected to wifi or mobile network or no network
  void rawListener(
    void Function(ConnectivityResult) onConnection, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  });
}
