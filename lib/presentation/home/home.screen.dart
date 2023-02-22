import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'controllers/home.controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<bool> onWillPop() async {
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('Do you want to exit an App'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes'),
                ),
              ],
            ),
          )) ??
          false;
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          left: false,
          right: false,
          bottom: false,
          child: Column(
            children: [
              Obx(() {
                return Expanded(
                  child: Opacity(
                    opacity: controller.isInitialLoaded.value ? 1 : 0.5,
                    child: WebView(
                      gestureNavigationEnabled: true,
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
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
