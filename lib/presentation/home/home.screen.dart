import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'controllers/home.controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late WebViewController _controller;
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('data'),
            Expanded(
              child: WebView(
                initialUrl: 'https://www.dripcodes.com',
                javascriptMode: JavascriptMode.unrestricted,
                javascriptChannels: <JavascriptChannel>{
                  JavascriptChannel(
                    name: 'Print',
                    onMessageReceived: (JavascriptMessage msg) {
                      debugPrint(msg.message);
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
      ),
    );
  }
}
