import 'dart:async';
import 'dart:io';
import 'package:ecompasscare/dal/core/network_state/network_state_mixin.dart';
import 'package:ecompasscare/dal/services/remote_db.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class HomeController extends GetxController with NetworkStateMixin1 {
  late LocationPermission permission;
  late final PlatformWebViewControllerCreationParams params;
  late final WebViewController webViewController;
  late final WebViewCookieManager cookieManager = WebViewCookieManager();
  static const String oneSignalAppId = '80786b47-31d8-4018-b284-5b5845b4bbb5';
  Timer? timer;
  late OSDeviceState? deviceState;
  String accessToken = '';
  File? file;
  RxBool firstLoad = false.obs;
  late final SharedPreferences prefs;

  initParams() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('stopTag') == null) {
      await prefs.setBool('stopTag', false);
    }

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    webViewController = WebViewController.fromPlatformCreationParams(params);

    if (webViewController.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);

      (webViewController.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);

      (webViewController.platform as AndroidWebViewController)
          .setOnShowFileSelector(
        (params) async {
          debugPrint(
              '\n--------------------\nstatement\n--------------------\n');

          ///TODO: Permission handler
          ///TODO: Drop down and image picker
          ///TODO: store api call variable in local :DONE
          FilePickerResult? result = await FilePicker.platform.pickFiles();

          if (result != null) {
            file = File(result.files.single.path ?? '');
          } else {
            return [];
          }
          return [(file?.uri).toString()];
        },
      );
    }

    await cookieManager.setCookie(
      const WebViewCookie(
        name: 'is_mobile_app',
        value: 'true',
        // domain: 'craftercms-delivery-dev.skill-mine.com',
        domain: 'sterling-accuris.skill-mine.com',
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
            firstLoad.value = true;
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint(
              '''Page resource error:\n code: ${error.errorCode}\n description: ${error.description}\n errorType: ${error.errorType}\n isForMainFrame: ${error.isForMainFrame}''',
            );
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains("mailto:") ||
                request.url.contains("tel:") ||
                request.url.contains("whatsapp:") ||
                request.url.contains("facebook") ||
                request.url.contains("maps") ||
                request.url.contains('v1/document')) {
              launchUrl(
                Uri.parse(request.url),
                mode: LaunchMode.externalApplication,
              );
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
          // 'https://craftercms-delivery-dev.skill-mine.com/mobile-homepage?is_app=true',
          'https://sterling-accuris.skill-mine.com/mobile-homepage?is_app=true',
        ),
      );
  }

  getLocation() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
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
  }

  void cookieTimer() {
    timer = Timer.periodic(
        const Duration(seconds: 5), (Timer t) => onListCookies());
  }

  Future<void> onListCookies() async {
    try {
      accessToken = await webViewController.runJavaScriptReturningResult(
          "localStorage.getItem('access_token')") as String;
      if (accessToken != null || accessToken != 'null' || accessToken != '') {
        await prefs.setString('loginToken', accessToken);
      }
    } catch (e) {
      debugPrint('Cookies Not Found!');
      accessToken = '';
      if (prefs.get('loginToken') != null) {
        //TODO: Call remove API
        prefs.remove('loginToken');
        prefs.setBool('stopTag', false);
      }
    }
    debugPrint(
        '--------------------------\n Cookies Found: $accessToken\n--------------------------');

    ///TODO: not working
    if (accessToken == '' || accessToken == 'null' || accessToken == null) {
      //
    } else {
      initNotification();
    }
  }

  Future<void> initNotification() async {
    if (prefs.getBool('stopTag') == false) {
      debugPrint('calling init noti');
      OneSignal.shared.setAppId(oneSignalAppId);
      OneSignal.shared
          .promptUserForPushNotificationPermission()
          .then((accepted) {
        //
      });
      deviceState = await OneSignal.shared.getDeviceState();
      if (deviceState != null) {
        String resp = await playerIDMap(accessToken, deviceState?.userId ?? '');
        debugPrint('API Response: $resp');
        if (resp == '200') {
          await prefs.setBool('stopTag', true);
        }
      }
    }
  }

  @override
  void onInit() async {
    await initParams();
    getLocation();
    Timer.periodic(
        const Duration(seconds: 5), (Timer t) => firstLoad.value = true);
    super.onInit();
  }

  @override
  void onReady() async {
    cookieTimer();

    // final status = await OneSignal.shared.getDeviceState();
    // final String? osUserID = status?.userId;
    // debugPrint('------------------- $osUserID');

    await initWebview();
    super.onReady();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
