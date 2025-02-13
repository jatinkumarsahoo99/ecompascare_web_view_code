import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'controllers/home.controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<bool> onWillPop() async {
      if (await controller.webViewController.canGoBack()) {
        controller.webViewController.goBack();
        return Future.value(false);
      } else {
        // ignore: use_build_context_synchronously
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
        ));
      }
    }

    return UpgradeAlert(
      upgrader: Upgrader(
        dialogStyle: Platform.isIOS
            ? UpgradeDialogStyle.cupertino
            : UpgradeDialogStyle.material,
        canDismissDialog: false,
        shouldPopScope: () => false,
        showIgnore: false,
        countryCode: 'IN',
        minAppVersion: '2.2.2',
        onUpdate: () {
          launchUrl(
            Uri.parse(
              Platform.isAndroid
                  ? 'https://play.google.com/store/apps/details?id=com.sterlingaccuris.android'
                  : 'https://apps.apple.com/in/app/sterling-accuris/id1329194345',
            ),
            mode: LaunchMode.externalApplication,
          );
          return false;
        },
      ),
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Obx(
            () {
              return controller.firstLoad.value == false
                  ? const Center(child: CircularProgressIndicator())
                  : SafeArea(
                      top: true,
                      left: false,
                      right: false,
                      bottom: false,
                      child: Column(
                        children: [
                          Expanded(
                            child: WebViewWidget(
                              controller: controller.webViewController,
                            ),
                          ),
                        ],
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
