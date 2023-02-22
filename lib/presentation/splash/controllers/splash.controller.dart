import 'package:ecompasscare/infrastructure/consts/asset_consts.dart';
import 'package:ecompasscare/infrastructure/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class SplashController extends GetxController {
  final double height = Get.height;
  final double width = Get.width;
  final bool repeat = false;

  void splashTimer() async {
    await Future.delayed(const Duration(milliseconds: 5000)).then(
      (value) {
        Get.offAllNamed(Routes.HOME);
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

  @override
  void onReady() {
    splashTimer();
    playSound();

    super.onReady();
  }
}
