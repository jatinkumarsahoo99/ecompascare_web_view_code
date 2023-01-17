import 'package:ecompasscare/dal/services/internet_connection_manager.dart';
import 'package:ecompasscare/dal/services/local_db.dart';
import 'package:ecompasscare/dal/services/local_storage.dart';

// late LocalDB localDB;

Future<void> initializeApp() async {
  await LocalStorage.instance.initialize();
  await ObjectBox.instance.initialize();
  InternetConnectionManager.instance.initialize();
}
