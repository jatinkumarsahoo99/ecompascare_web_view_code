import 'package:base_flutter/infrastructure/consts/asset_consts.dart';
import 'package:base_flutter/infrastructure/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'controllers/home.controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () {
          return controller.splashBool.value
              ? Center(child: Image.asset(AssetConsts.splash))
              : Column(
                  children: [
                    const SizedBox(height: 33),
                    LinearProgressIndicator(
                      value: controller.progress.value.toDouble(),
                      backgroundColor: Colors.blue,
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                      minHeight: 2,
                    ),
                    Expanded(
                      child: Opacity(
                        opacity: controller.isInitialLoaded.value ? 1 : 0.5,
                        child: WebView(
                          initialUrl:
                              'https://craftercms-delivery-dev.skill-mine.com/?crafterSite=ecompasscaredev',
                          javascriptMode: JavascriptMode.unrestricted,
                          javascriptChannels: <JavascriptChannel>{
                            JavascriptChannel(
                              name: 'Print',
                              onMessageReceived: (JavascriptMessage msg) {
                                debugPrint(msg.message);
                                if (msg.message == 'Hello!') {
                                  Get.toNamed(Routes.SECOND);
                                }
                              },
                            ),
                          },
                          onPageFinished: (String url) {
                            if (!controller.isInitialLoaded.value) {
                              controller.isInitialLoaded.value = true;
                            }
                          },
                          onProgress: (progress) {
                            controller.progress.value = progress;
                          },
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
                );
        },
      ),
    );
  }
}
