import 'package:ecompasscare/infrastructure/consts/asset_consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'controllers/splash.controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Lottie.asset(
                  AssetConsts.lottieSplash,
                  fit: BoxFit.fill,
                  repeat: controller.repeat,
                  alignment: Alignment.center,
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                width: Get.width,
                color: const Color(0xff6C3F94).withOpacity(0.3),
                child: Center(
                  child: Obx(() => Text(
                        'Version: ${controller.packageInfo.value.version}(${controller.packageInfo.value.buildNumber})',
                      )),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ],
      ),
    );
  }
}
