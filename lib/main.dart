import 'package:base_flutter/infrastructure/config.dart';
import 'package:base_flutter/infrastructure/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'infrastructure/initialize_app.dart';
import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/navigation/routes.dart';

void main() async {
  var initialRoute = await Routes.initialRoute;
  WidgetsFlutterBinding.ensureInitialized();

  ///REMEMBER: set proper environment here before deploy
  ConfigEnvironments.currentEnvironments = Environments.LOCAL;
  await initializeApp();
  runApp(Main(initialRoute));
}

class Main extends StatelessWidget {
  final String initialRoute;

  const Main(this.initialRoute, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: initialRoute,
      getPages: Nav.routes,
      theme: Themes.light,
    );
  }
}
