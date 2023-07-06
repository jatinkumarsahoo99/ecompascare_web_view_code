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
import 'package:image_picker/image_picker.dart';
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
  String oneSignalAppId = ConfigEnvironments.env['OSAppId'];
  Timer? timer;
  late OSDeviceState? deviceState;
  String accessToken = '';
  bool clearStorage = false;
  File? file;
  RxBool firstLoad = false.obs;
  late final SharedPreferences prefs;
  FileDetails fileDetails = FileDetails();
  bool serviceEnabled = false;
  Position loc = Position(
    longitude: 0.0,
    latitude: 0.0,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
  );
  File? pickedFile;
  ImageSource iSource = ImageSource.gallery;

  @override
  void onInit() async {
    accessToken = '';
    await initNotification();
    await getLocation();
    await initParams();
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

  initParams() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('notiSync') == null) {
      await prefs.setBool('notiSync', false);
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

      ///TODO: Zoom fix;
      (webViewController.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);

      (webViewController.platform as AndroidWebViewController)
          .setOnShowFileSelector(
        (params) async {
          await Get.bottomSheet(
            Container(
              height: 200,
              color: Colors.white,
              child: Center(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text("Open Camera"),
                      onTap: () {
                        iSource = ImageSource.camera;
                        Get.back();
                      },
                    ),
                    ListTile(
                      title: const Text("Upload from Files"),
                      onTap: () async {
                        iSource = ImageSource.gallery;
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ).then(
            (value) async => {
              if (iSource == ImageSource.camera)
                {
                  pickedFile = File(
                    (await ImagePicker().pickImage(source: iSource))?.path ??
                        '',
                  )
                }
              else
                {
                  pickedFile = File(
                    (await FilePicker.platform.pickFiles())
                            ?.files
                            .single
                            .path ??
                        '',
                  ),
                }
            },
          );

          if (pickedFile != null) {
            return [(pickedFile?.uri).toString()];
          } else {
            return [];
          }
        },
      );
    }
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
          onPageStarted: (String url) async {
            if (clearStorage == false) {
              try {
                await webViewController.runJavaScript(
                    "localStorage.removeItem('mobile_current_location')");
                await webViewController
                    .runJavaScript("localStorage.removeItem('selected_city')");
                await webViewController.runJavaScript(
                    "localStorage.removeItem('selected_location')");
                clearStorage = true;
              } catch (e) {
                debugPrint('ERROR: $e');
              }
            }
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
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (permission == LocationPermission.denied) {
      try {
        permission = await Geolocator.requestPermission();
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
      } catch (e) {
        debugPrint(e.toString());
      }
      if ((permission == LocationPermission.whileInUse ||
              permission == LocationPermission.whileInUse) &&
          serviceEnabled) {
        loc = await Geolocator.getCurrentPosition();
        debugPrint('--------------\n1. $loc\n--------------');
      } else {
        debugPrint('--------------\nLocation Denied\n--------------');
      }
    } else if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        loc = await Geolocator.getCurrentPosition();
        debugPrint('--------------\n2. $loc\n--------------');
      } else {
        debugPrint('--------------\nLocation is OFF\n--------------');
      }
    } else {
      debugPrint('--------------\nPermission Denied\n--------------');
    }
  }

  void localStoreLocation() {
    Geolocator.getPositionStream().listen((Position streamPos) async {
      debugPrint('--------------\n Stream: $streamPos\n--------------');
      try {
        ///Not working in iOS
        // await webViewController
        //     .runJavaScript("localStorage.setItem('mobileLat','test')");
        // await webViewController
        //     .runJavaScript("localStorage.setItem('mobileLat','test')");
        //  await webViewController.runJavaScript(
        //     "document.getElementsByClassName('someclassname')[0]");

        ///Working
        // debugPrint('Working');
        // await webViewController.runJavaScript('console.log("Test")');

        ///Testing
        // debugPrint('Testing');
        // await webViewController.runJavaScript(
        //   'caches.open("test_caches_entry"); localStorage["test_localStorage"] = "dummy_entry";',
        // );
        // await webViewController.runJavaScriptReturningResult(
        //     "localStorage.setItem('myData', 'Hello World!');");
        // debugPrint('----------------------');

        ///Working in Android
        await webViewController.runJavaScript(
            "localStorage.setItem('mobileLat',${streamPos.latitude})");
        await webViewController.runJavaScript(
            "localStorage.setItem('mobileLong',${streamPos.longitude})");
      } catch (e) {
        debugPrint('Error: $e');
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
      accessToken = await webViewController.runJavaScriptReturningResult(
          "localStorage.getItem('access_token')") as String;
      debugPrint('$accessToken------------------');

      ///Android comes with extra " in the beginning and end.
      if (Platform.isAndroid) {
        accessToken = accessToken.substring(1, accessToken.length - 1);
      }
      if (accessToken == 'ul') {
        debugPrint('Null');
        accessToken = '';
      } else {
        debugPrint('Found:$accessToken------------------');
        await prefs.setString('loginToken', accessToken);
      }
    } catch (e) {
      debugPrint('Cookies Not Found!');
      accessToken = '';
      if (prefs.get('loginToken') != null) {
        //TODO: Call remove playerID API
        prefs.remove('loginToken');
        prefs.setBool('notiSync', false);
      }
    }
    debugPrint(
        '--------------------------\n Token Found: $accessToken\n--------------------------');

    ///TODO: not working
    if (accessToken == 'ul' || accessToken == '') {
      debugPrint('Notification Not calling');
    } else {
      // initNotification();
      if (prefs.getBool('notiSync') == false) {
        debugPrint('calling Player ID sync');
        deviceState = await OneSignal.shared.getDeviceState();
        debugPrint('Device ID before: ${deviceState?.userId}');
        if (deviceState?.userId != null) {
          String resp =
              await playerIDMap(accessToken, deviceState?.userId ?? '');
          debugPrint('Device ID: ${deviceState?.userId}');
          debugPrint('API Response: $resp');
          if (resp == '200') {
            await prefs.setBool('notiSync', true);
          }
        }
      }
    }
  }

  Future<void> initNotification() async {
    debugPrint('calling init noti');
    OneSignal.shared.setAppId(oneSignalAppId);
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      //
    });
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      debugPrint(
        'NOTIFICATION OPENED HANDLER CALLED WITH: $result ${result.notification.launchUrl}',
      );
      webViewController.loadRequest(
        Uri.parse(result.notification.launchUrl?.isNotEmpty ?? false
            ? '${result.notification.launchUrl}'
            : 'https://${ConfigEnvironments.env['domain']}/patient-portal/notifications'),
      );
    });
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      debugPrint('FOREGROUND HANDLER CALLED WITH: $event');
      event.complete(event.notification);
    });
  }
}
