import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/navigation/routes.dart';

void main() async {
  var initialRoute = await Routes.initialRoute;
  // WidgetsFlutterBinding.ensureInitialized();
  ///REMEMBER: set proper environment here before deploy
  // ConfigEnvironments.currentEnvironments = Environments.LOCAL;
  // await initializeApp();
  runApp(Main(initialRoute));
}

class Main extends StatelessWidget {
  final String initialRoute;

  const Main(this.initialRoute, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: Nav.routes,
      // theme: Themes.light,
    );
  }
}
