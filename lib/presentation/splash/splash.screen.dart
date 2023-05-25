import 'package:ecompasscare/infrastructure/consts/asset_consts.dart';
import 'package:ecompasscare/infrastructure/navigation/routes.dart';
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Obx(
                  () {
                    return controller.showConsent.value
                        ? Container(
                            height: Get.height,
                            width: Get.width,
                            color: Colors.black87,
                            alignment: Alignment.center,
                            child: Container(
                              height: 300,
                              width: 330,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 30,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller.dialogContent.value.toString(),
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            controller.showConsent.value =
                                                false;
                                            controller.prefs.setBool(
                                                'localshowConsent', false);
                                            Get.offAllNamed(Routes.HOME);
                                          },
                                          child: const Text('Deny'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            controller.showConsent.value =
                                                false;
                                            controller.prefs.setBool(
                                                'localshowConsent', false);
                                            Get.offAllNamed(Routes.HOME);
                                          },
                                          child: const Text('Accept'),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
