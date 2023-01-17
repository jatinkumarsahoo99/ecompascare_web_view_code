import 'package:ecompasscare/dal/core/network_response/network_response.dart';
import 'package:get/get.dart';

///This enum is for Network State of a particular api call
///states are => notStarted, loading, error, noInternet, success
enum NetworkState { notStarted, loading, error, noInternet, success }

///This is a mixin and this is punched with the controller and gives controller
///two method networkObserver1 and networkObserver2 inside which api calls need to done
mixin NetworkStateMixin1 {
  ///this gives the current network state to the controller among
  ///notStarted, loading, error, noInternet, success
  ///of the api call done through networkObserver1
  NetworkState get networkState1 => _networkState1.value;

  ///this gives to the controller NetworkStatus of the api call done through networkObserver1
  NetworkStatus get networkStatus1 => _networkStatus1.value;

  final Rx<NetworkStatus> _networkStatus1 =
      Rx<NetworkStatus>(const NetworkStatus.init());

  final Rx<NetworkState> _networkState1 =
      Rx<NetworkState>(NetworkState.notStarted);

  ///this is the method which expects a method which will return NetworkStatus in future
  ///so once future method of api call is passed it will immediately set networkState1 to
  ///NetworkState.loading from NetworkState.notStarted then at the end of the api call it expects
  ///a NetworkStatus in return by which it sets networkState1 either to error or success
  networkObserver1(Future<NetworkStatus> Function() observer) async {
    _networkState1(NetworkState.loading);
    _networkStatus1.value = await observer();
    if (!_networkStatus1.value.isError) {
      _networkState1(NetworkState.success);
    } else if (_networkStatus1.value.isOffline) {
      _networkState1(NetworkState.noInternet);
    } else {
      _networkState1(NetworkState.error);
    }
  }
}

///This is a mixin and this is punched with the controller and gives controller
///the method networkObserver2 inside which api calls need to done
mixin NetworkStateMixin2 on NetworkStateMixin1 {
  ///this gives the current network state to the controller among
  ///notStarted, loading, error, noInternet, success
  ///of the api call done through networkObserver2
  NetworkState get networkState2 => _networkState2.value;

  ///this gives to the controller NetworkStatus of the api call done through networkObserver2
  NetworkStatus get networkStatus2 => _networkStatus2.value;

  final Rx<NetworkStatus> _networkStatus2 =
      Rx<NetworkStatus>(const NetworkStatus.init());

  final Rx<NetworkState> _networkState2 =
      Rx<NetworkState>(NetworkState.notStarted);

  ///this is the method which expects a method which will return NetworkStatus in future
  ///so once future method of api call is passed it will immediately set networkState2 to
  ///NetworkState.loading from NetworkState.notStarted then at the end of the api call it expects
  ///a NetworkStatus in return by which it sets networkState2 either to error or success
  networkObserver2(Future<NetworkStatus> Function() observer) async {
    _networkState2(NetworkState.loading);
    _networkStatus2.value = await observer();
    if (!_networkStatus2.value.isError) {
      _networkState2(NetworkState.success);
    } else if (_networkStatus2.value.isOffline) {
      _networkState2(NetworkState.noInternet);
    } else {
      _networkState2(NetworkState.error);
    }
  }
}

///This is a mixin and this is punched with the controller and gives controller
///the method networkObserver3 inside which api calls need to done
mixin NetworkStateMixin3 on NetworkStateMixin2 {
  ///this gives the current network state to the controller among
  ///notStarted, loading, error, noInternet, success
  NetworkState get networkState3 => _networkState3.value;

  ///this gives to the controller Network Status of the api call done through networkObserver3
  NetworkStatus get networkStatus3 => _networkStatus3.value;

  final Rx<NetworkStatus> _networkStatus3 =
      Rx<NetworkStatus>(const NetworkStatus.init());

  final Rx<NetworkState> _networkState3 =
      Rx<NetworkState>(NetworkState.notStarted);

  ///this is the method which expects a method which will return NetworkStatus in future
  ///so once future method of api call is passed it will immediately set networkState3 to
  ///NetworkState.loading from NetworkState.notStarted then at the end of the api call it expects
  ///a NetworkStatus in return by which it sets networkState3 either to error or success
  networkObserver3(Future<NetworkStatus> Function() observer) async {
    _networkState3(NetworkState.loading);
    _networkStatus3.value = await observer();
    if (!_networkStatus3.value.isError) {
      _networkState3(NetworkState.success);
    } else if (_networkStatus3.value.isOffline) {
      _networkState3(NetworkState.noInternet);
    } else {
      _networkState3(NetworkState.error);
    }
  }
}
