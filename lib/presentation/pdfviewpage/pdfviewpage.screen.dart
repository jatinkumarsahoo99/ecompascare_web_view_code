import 'package:ecompasscare/infrastructure/navigation/routes.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/pdfviewpage.controller.dart';

class PdfviewpageScreen extends GetView<PdfviewpageController> {
  const PdfviewpageScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          'PdfviewpageScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Get.toNamed(Routes.HOME);
      }),
    );
  }
}
