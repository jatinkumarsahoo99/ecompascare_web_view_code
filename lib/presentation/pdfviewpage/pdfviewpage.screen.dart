import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'controllers/pdfviewpage.controller.dart';
import 'dart:io' show Platform;

class PdfviewpageScreen extends GetView<PdfviewpageController> {
  const PdfviewpageScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => Platform.isIOS ? false : true,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.download),
          onPressed: () {
            launchUrl(
              Uri.parse(controller.link.value),
              mode: LaunchMode.externalApplication,
              webViewConfiguration: const WebViewConfiguration(
                enableDomStorage: true,
                enableJavaScript: true,
                headers: {'test': 'test'},
              ),
              webOnlyWindowName: '_blank',
            );
          },
        ),
        body: Stack(
          children: [
            SfPdfViewer.network(
              controller.link.value,
            ),
            Positioned(
              top: 40,
              right: 20,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.black,
                      width: 1.5,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  height: 30,
                  width: 30,
                  child: const Center(
                      child: Icon(
                    Icons.close,
                    size: 20,
                  )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
