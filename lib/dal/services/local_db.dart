import 'package:base_flutter/dal/core/network_response/network_response.dart';
import 'package:base_flutter/dal/services/internet_connection_manager.dart';
import 'package:objectbox/objectbox.dart';

///TODO: Check this file only if you need to use local database
class ObjectBox {
  late final Store _store;

  Store get store => _store;

  ObjectBox._();

  static final ObjectBox instance = ObjectBox._();

  Future<void> initialize() async {
    // _store = await openStore();
  }

  void close() {
    _store.close();
  }
}

class LocalDB<T> {
  // LocalDB._();
  // static final LocalDB instance = LocalDB._();

  NetworkResponse<T> localSync(NetworkResponse<T> remoteResponse) {
    if (InternetConnectionManager.instance.isInternetConnected) {
      _syncResponse(remoteResponse.body);
      return remoteResponse;
    } else {
      return NetworkResponse.offline(body: _getOfflineResponse());
    }
  }

  T? _getOfflineResponse() {
    List<T> res = ObjectBox.instance.store.box<T>().getAll();
    if (res.isNotEmpty) {
      return res.first;
    } else {
      return null;
    }
  }

  int _syncResponse(T? overview) {
    if (overview != null) {
      _deleteAllResponse();
      return ObjectBox.instance.store.box<T>().put(overview);
    } else {
      return -1;
    }
  }

  int _deleteAllResponse() {
    return ObjectBox.instance.store.box<T>().removeAll();
  }
}
