import 'dart:io';
import 'package:ecompasscare/infrastructure/navigation/routes.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  final bool repeat = false;
  RxBool showConsent = false.obs;
  RxString dialogContent = ''.obs;

  late final SharedPreferences prefs;

  @override
  void onReady() {
    splashTimer();
    firebaseRead();
    super.onReady();
  }

  @override
  Future<void> onInit() async {
    prefs = await SharedPreferences.getInstance();
    super.onInit();
  }

  void splashTimer() async {
    await Future.delayed(const Duration(milliseconds: 5000)).then(
      (value) async {
        await firebaseRead();
        if (showConsent.value == false) {
          Get.offAllNamed(Routes.HOME);
        }
      },
    );
  }

  firebaseRead() async {
    var consentVisibility = await firebaseGet("consentVisibility");
    debugPrint('------------$consentVisibility----------');
    if (Platform.isAndroid) {
      if (consentVisibility.toString() == 'true') {
        if (prefs.getBool('localshowConsent') == null) {
          debugPrint('1. visible true');
          dialogContent.value = await firebaseGet("content");
          showConsent.value = true;
        }
      } else {
        debugPrint('1. visible false');
        showConsent.value = false;
      }
    }
  }

  firebaseGet(String value) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(value);
    DatabaseEvent event = await ref.once();
    return event.snapshot.value.toString();
  }
}
