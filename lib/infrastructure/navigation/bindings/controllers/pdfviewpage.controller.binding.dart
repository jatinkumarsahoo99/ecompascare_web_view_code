import 'package:get/get.dart';

import '../../../../presentation/pdfviewpage/controllers/pdfviewpage.controller.dart';

class PdfviewpageControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PdfviewpageController>(
      () => PdfviewpageController(),
    );
  }
}
