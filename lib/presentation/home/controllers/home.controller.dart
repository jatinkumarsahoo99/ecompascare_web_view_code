import 'dart:async';
import 'dart:io';
import 'package:ecompasscare/dal/core/network_state/network_state_mixin.dart';
import 'package:ecompasscare/dal/services/remote_db.dart';
import 'package:ecompasscare/domain/entity/file_details.dart';
import 'package:ecompasscare/infrastructure/config.dart';
import 'package:ecompasscare/infrastructure/navigation/routes.dart';
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

///TODO: ios notification setup

class HomeController extends GetxController with NetworkStateMixin1 {
  late LocationPermission permission;
  late final PlatformWebViewControllerCreationParams params;
  late final WebViewController webViewController;
  late final WebViewCookieManager cookieManager = WebViewCookieManager();
  String oneSignalAppId = ConfigEnvironments.env['OSAppId'];
  Timer? timer;
  late OSDeviceState? deviceState;
  String accessToken = '';
  File? file;
  RxBool firstLoad = false.obs;
  late final SharedPreferences prefs;
  FileDetails fileDetails = FileDetails();
  Position loc = Position(
      longitude: 0.0,
      latitude: 0.0,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);
  RxString testRx = ''.obs;
  RxString testRx1 = ''.obs;

  initParams() async {
    var env = ConfigEnvironments.env['url'];
    debugPrint('\n-----------------------\n$env\n-----------------------\n');

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
      ///TODO: Zoom fix;
      webViewController.setUserAgent(
        'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.82 Mobile Safari/537.36',
      );

      // AndroidWebViewController.enableDebugging(true);
      ///TODO: Zoom fix;
      (webViewController.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);

      (webViewController.platform as AndroidWebViewController)
          .setOnShowFileSelector(
        (params) async {
          ///TODO: Drop down and image picker
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

    //Adding Cookie
    // await cookieManager.setCookie(
    //   WebViewCookie(
    //     name: 'is_mobile_app',
    //     value: 'true',
    //     domain: ConfigEnvironments.env['domain'],
    //   ),
    // );
  }

  initWebview() {
    webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)

      ///TODO: Zoom fix;
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

            ///TODO: Zoom fix;
            webViewController.runJavaScript(
                'document.documentElement.style.zoom = ${1 / 1.0};');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint(
              '''Page resource error:\n code: ${error.errorCode}\n description: ${error.description}\n errorType: ${error.errorType}\n isForMainFrame: ${error.isForMainFrame}''',
            );
          },
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.contains("mailto:") ||
                request.url.contains("tel:") ||
                request.url.contains("whatsapp:") ||
                request.url.contains("facebook") ||
                request.url.contains("maps")) {
              launchUrl(
                Uri.parse(request.url),
                mode: LaunchMode.externalApplication,
              );
              return NavigationDecision.prevent;
            } else if (request.url.contains('v1/document')) {
              fileDetails = await fileDetailsAPI(
                  prefs.getString('loginToken') ?? '',
                  request.url.split('document/')[1]);
              Get.toNamed(
                Routes.PDFVIEWPAGE,
                arguments: {
                  'url': request.url,
                  'fileType':
                      (fileDetails.data?.docType ?? '').contains('image')
                          ? 'image'
                          : 'pdf',
                },
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
      ..loadRequest(loc.longitude != 0.0
          ? Uri.parse(ConfigEnvironments.env['url'] +
              '&lat=' +
              loc.latitude.toString() +
              '&long=' +
              loc.longitude.toString() +
              '&timeStamp=' +
              DateTime.now().toString())
          : Uri.parse(ConfigEnvironments.env['url']));
  }

  getLocation() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      try {
        permission = await Geolocator.requestPermission();
      } catch (e) {
        debugPrint(e.toString());
      }
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.whileInUse) {
        loc = await Geolocator.getCurrentPosition();
        debugPrint('--------------\n1. $loc\n--------------');
      } else {
        debugPrint('--------------\nLocation Denied\n--------------');
      }
    } else if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      loc = await Geolocator.getCurrentPosition();
      debugPrint('--------------\n2. $loc\n--------------');
    } else {
      debugPrint('--------------\nPermission Denied\n--------------');
    }
  }

  void localStoreLocation() {
    Geolocator.getPositionStream().listen((Position streamPos) async {
      debugPrint('--------------\n Stream: $streamPos\n--------------');
      try {
        // await webViewController.runJavaScript("console.log('Testing');");
        // await webViewController
        //     .runJavaScript("localStorage.setItem('mobileLat','test')");
        await webViewController.runJavaScriptReturningResult(
            "localStorage.setItem('mobileLat',${streamPos.latitude})");
        await webViewController.runJavaScriptReturningResult(
            "localStorage.setItem('mobileLong',${streamPos.longitude})");
      } catch (e) {
        debugPrint(e.toString());
        debugPrint('LocalStorage Failed.');
      }
    });
  }

  void cookieTimer() {
    timer = Timer.periodic(
        const Duration(seconds: 5), (Timer t) => onListCookies());
  }

  Future<void> onListCookies() async {
    try {
      testRx.value = await webViewController
          .runJavaScript("localStorage.getItem('mobileLat')") as String;
      testRx1.value = await webViewController
          .runJavaScript("localStorage.getItem('mobileLong')") as String;
    } catch (e) {
      debugPrint('exc: $e');
    }

    try {
      accessToken = await webViewController.runJavaScriptReturningResult(
          "localStorage.getItem('access_token')") as String;
      debugPrint('$accessToken------------------');
      accessToken = accessToken.substring(1, accessToken.length - 1);
      if (accessToken == 'ul') {
        debugPrint('Null');
        accessToken = '';
      } else {
        debugPrint('Not found:$accessToken------------------');
        await prefs.setString('loginToken', accessToken);
      }
    } catch (e) {
      debugPrint('Cookies Not Found!');
      accessToken = '';
      if (prefs.get('loginToken') != null) {
        //TODO: Call remove playerID API
        prefs.remove('loginToken');
        prefs.setBool('stopTag', false);
      }
    }
    debugPrint(
        '--------------------------\n Token Found: $accessToken\n--------------------------');

    ///TODO: not working
    if (accessToken == 'ul') {
      debugPrint('Notification Not calling');
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
      OneSignal.shared
          .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
        debugPrint('NOTIFICATION OPENED HANDLER CALLED WITH: $result');
        webViewController.loadRequest(
          Uri.parse(
            'https://${ConfigEnvironments.env['domain']}/patient-portal/notifications?is_app=true',
          ),
        );
      });
      // OneSignal.shared.setNotificationWillShowInForegroundHandler(
      //     (OSNotificationReceivedEvent event) {
      //   debugPrint('FOREGROUND HANDLER CALLED WITH: $event');

      //   /// Display Notification, send null to not display
      //   event.complete(null);
      // });
      deviceState = await OneSignal.shared.getDeviceState();
      if (deviceState != null) {
        String resp = await playerIDMap(accessToken, deviceState?.userId ?? '');

        debugPrint('Device ID: ${deviceState?.userId}');
        debugPrint('API Response: $resp');
        if (resp == '200') {
          await prefs.setBool('stopTag', true);
        }
      }
    }
  }

  @override
  void onInit() async {
    await getLocation();
    await initParams();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      localStoreLocation();
    }
    Timer.periodic(
        const Duration(seconds: 5), (Timer t) => firstLoad.value = true);
    super.onInit();
  }

  @override
  void onReady() async {
    cookieTimer();
    await initWebview();
    super.onReady();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
