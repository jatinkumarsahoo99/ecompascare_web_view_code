import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/navigation/routes.dart';

void main() async {
  var initialRoute = await Routes.initialRoute;
  // WidgetsFlutterBinding.ensureInitialized();
  // ConfigEnvironments.currentEnvironments = Environments.LOCAL;
  runApp(Main(initialRoute));
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  // //Remove this method to stop OneSignal Debugging
  // OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  // OneSignal.shared.printInfo();
  // OneSignal.shared.setAppId("YOUR_ONESIGNAL_APP_ID");
  // // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  // OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
  //   debugPrint("Accepted permission: $accepted");
  // });
  // OneSignal.shared.setNotificationWillShowInForegroundHandler(
  //     (OSNotificationReceivedEvent event) {
  //   // Will be called whenever a notification is received in foreground
  //   // Display Notification, pass null param for not displaying the notification
  //   event.complete(event.notification);
  // });
}

class Main extends StatefulWidget {
  static const String oneSignalAppId = '80786b47-31d8-4018-b284-5b5845b4bbb5';
  // static const String oneSignalAppId = '2eff7b0b-35e6-49e2-b44b-b163750c32a2';

  final String initialRoute;
  const Main(this.initialRoute, {super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: widget.initialRoute,
      getPages: Nav.routes,
    );
  }
}
