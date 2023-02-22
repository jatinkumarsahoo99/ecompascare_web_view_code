import 'package:ecompasscare/dal/core/network_state/network_state_mixin.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class HomeController extends GetxController with NetworkStateMixin1 {
  late LocationPermission permission;
  final isInitialLoaded = false.obs;

  getLocation() async {
    try {
      permission = await Geolocator.requestPermission();
    } catch (e) {
      debugPrint(e.toString());
    }
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position loc;
      loc = await Geolocator.getCurrentPosition();
      debugPrint(loc.toString());
    }
  }

  @override
  void onInit() {
    getLocation();
    super.onInit();
  }
}

// testApiCall() async {
//   ///Need to put all the places await where needed
//   await networkObserver1(() async {
//     NetworkResponse<TestResponse> response =
//         await TestDao.instance.testGetApi();

//     /// You have the response json converted to [TestResponse]
//     /// and kept in [response.body]
//     /// can use it here

//     /// After using [response.body] need to return [response.status]
//     /// to networkObserverX, for 1 api call use [NetworkStateMixin1]
//     /// for 2 api calls use [NetworkStateMixin1, NetworkStateMixin2] and so on

//     return response.status;
//   });
// }
