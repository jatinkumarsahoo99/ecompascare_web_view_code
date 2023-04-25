import 'package:ecompasscare/firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'infrastructure/config.dart';
import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/navigation/routes.dart';

void main() async {
  var initialRoute = await Routes.initialRoute;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // var prodInfo = await firebaseGet();
  // debugPrint('------------$prodInfo----------');
  ConfigEnvironments.currentEnvironments = Environments.PRODUCTION;
  // ConfigEnvironments.currentEnvironments =
  //     prodInfo == 'true' ? Environments.PRODUCTION : Environments.DEV;

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  runApp(Main(initialRoute));
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
}

// firebaseGet() async {
//   DatabaseReference ref = FirebaseDatabase.instance.ref("prod");
//   DatabaseEvent event = await ref.once();
//   return event.snapshot.value.toString();
// }

class Main extends StatefulWidget {
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
