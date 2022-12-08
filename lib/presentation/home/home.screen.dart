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
      // appBar: AppBar(
      //   title: const Text('HomeView'),
      // ),
      // resizeToAvoidBottomInset: false,
      // extendBody: true,
      // extendBodyBehindAppBar: true,
      body: Column(
        children: [
          const SizedBox(height: 35),
          Expanded(
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
              // onProgress: (progress) {
              //   if (progress != 100) {
              //     _progress.value = true;
              //   }
              // },
              // onWebViewCreated: (controller) {
              //   _controller = controller;
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
        ],
      ),
    );
  }
}
