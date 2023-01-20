import 'package:ecompasscare/dal/core/network_state/network_state_mixin.dart';
import 'package:ecompasscare/infrastructure/consts/asset_consts.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class HomeController extends GetxController with NetworkStateMixin1 {
  late LocationPermission permission;

  final RxBool splashBool = true.obs;
  final isInitialLoaded = false.obs;
  // final RxInt progress = 0.obs;

  void splashTimer() async {
    await Future.delayed(const Duration(milliseconds: 5000)).then(
      (value) {
        splashBool.value = false;
        // player.stop();
        getLocation();
      },
    );
  }

  playSound() async {
    final player = AudioPlayer();
    try {
      await player.setAsset(AssetConsts.audioSplash);
      player.play();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  getLocation() async {
    try {
      permission = await Geolocator.requestPermission();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void onInit() {
    splashTimer();
    playSound();
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
