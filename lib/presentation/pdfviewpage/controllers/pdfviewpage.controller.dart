import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PdfviewpageController extends GetxController {
  RxString link = ''.obs;

  @override
  void onInit() {
    link.value = Get.arguments;
    debugPrint('\n----------------------\n$link\n----------------------\n');
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
