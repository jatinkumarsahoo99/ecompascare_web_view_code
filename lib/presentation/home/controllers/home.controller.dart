import 'package:ecompasscare/dal/core/network_state/network_state_mixin.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class HomeController extends GetxController with NetworkStateMixin1 {
  late LocationPermission permission;
  late final PlatformWebViewControllerCreationParams params;
  late final WebViewController webViewController;
  late final WebViewCookieManager cookieManager = WebViewCookieManager();
  final RxString testCookies = ''.obs;

  initParams() async {
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    webViewController = WebViewController.fromPlatformCreationParams(params);

    await cookieManager.setCookie(
      const WebViewCookie(
        name: 'is_mobile_app',
        value: 'true',
        domain: 'craftercms-delivery-dev.skill-mine.com',
      ),
    );
  }

  initWebview() {
    webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint(
              '''Page resource error:\n code: ${error.errorCode}\n description: ${error.description}\n errorType: ${error.errorType}\n isForMainFrame: ${error.isForMainFrame}''',
            );
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains("mailto:")) {
              launchUrl(Uri.parse(request.url));
              return NavigationDecision.prevent;
            } else if (request.url.contains("tel:")) {
              launchUrl(Uri.parse(request.url));
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      )
      // ..addJavaScriptChannel(
      //   'Toaster',
      //   onMessageReceived: (JavaScriptMessage message) {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text(message.message)),
      //     );
      //   },
      // )
      ..loadRequest(
        Uri.parse(
          'https://craftercms-delivery-dev.skill-mine.com/mobile-homepage?is_app=true',
        ),
      );
  }

  getLocation() async {
    try {
      permission = await Geolocator.requestPermission();
    } catch (e) {
      debugPrint(e.toString());
    }
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position loc;
      loc = await Geolocator.getCurrentPosition();
      debugPrint(loc.toString());
    }
  }

  Future<void> onListCookies(BuildContext context) async {
    final String cookies = await webViewController
        .runJavaScriptReturningResult('document.cookie') as String;
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Cookies:'),
              _getCookieList(cookies),
            ],
          ),
        ),
      );
    }
  }

  Widget _getCookieList(String cookies) {
    if (cookies == null || cookies == '""') {
      return Container();
    }
    final List<String> cookieList = cookies.split(';');
    final Iterable<Text> cookieWidgets =
        cookieList.map((String cookie) => Text(cookie));
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: cookieWidgets.toList(),
    );
  }

  @override
  void onInit() async {
    await initParams();
    getLocation();
    super.onInit();
  }

  @override
  void onReady() async {
    testCookies.value = await webViewController
        .runJavaScriptReturningResult('document.cookie') as String;
    await initWebview();
    super.onReady();
  }
}
