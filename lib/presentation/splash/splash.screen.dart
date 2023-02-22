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
      body: Column(
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
    );
  }
}
