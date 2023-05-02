import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PdfviewpageController extends GetxController {
  RxString link = ''.obs;
  RxString fileType = ''.obs;

  @override
  void onInit() {
    if (Get.arguments is Map) {
      link.value = (Get.arguments as Map)['url'];
      fileType.value = (Get.arguments as Map)['fileType'];
    }
    debugPrint(
        '\n----------------------\n$fileType : $link\n----------------------\n');
    super.onInit();
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
