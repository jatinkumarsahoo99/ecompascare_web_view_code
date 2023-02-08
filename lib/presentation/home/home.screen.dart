import 'package:ecompasscare/infrastructure/consts/asset_consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'controllers/home.controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return controller.splashBool.value
            ? Column(
                children: [
                  Expanded(
                    child: Lottie.asset(
                      AssetConsts.lottieSplash,
                      fit: BoxFit.fill,
                      repeat: false,
                      alignment: Alignment.center,
                    ),
                  ),
                ],
              )
            : Container(
                color: controller.splashBool.value
                    ? const Color(0xff6C3F94)
                    : Colors.white,
                child: SafeArea(
                  top: true,
                  left: false,
                  right: false,
                  bottom: false,
                  child: Column(
                    children: [
                      // const SizedBox(height: 15),
                      // LinearProgressIndicator(
                      //   value: controller.progress.value.toDouble(),
                      //   backgroundColor: Colors.blue,
                      //   valueColor: const AlwaysStoppedAnimation(Colors.white),
                      //   minHeight: 2,
                      // ),
                      Expanded(
                        child: Opacity(
                          opacity: controller.isInitialLoaded.value ? 1 : 0.5,
                          child: WebView(
                            initialUrl:
                                'https://craftercms-delivery-dev.skill-mine.com/mobile-homepage?is_app=true',
                            javascriptMode: JavascriptMode.unrestricted,
                            zoomEnabled: false,
                            onPageFinished: (String url) {
                              if (!controller.isInitialLoaded.value) {
                                controller.isInitialLoaded.value = true;
                              }
                            },
                            // onProgress: (progress) {
                            //   controller.progress.value = progress;
                            // },
                            // javascriptChannels: <JavascriptChannel>{
                            //   JavascriptChannel(
                            //     name: 'Print',
                            //     onMessageReceived: (JavascriptMessage msg) {
                            //       debugPrint(msg.message);
                            //       if (msg.message == 'Hello!') {
                            //         Get.toNamed(Routes.SECOND);
                            //       }
                            //     },
                            //   ),
                            // },
                            // onPageFinished: (finish) async {
                            //   final response = await _controller.runJavascriptReturningResult(
                            //       "document.documentElement.innerText");
                            //   if (response.contains('We are sorry but the transaction failed.')) {
                            //     debugPrint('statement1');
                            //   } else if (response.contains('Payment Successful')) {
                            //     debugPrint('statement2');
                            //   }
                            // },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
