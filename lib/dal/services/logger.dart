import 'dart:developer';

///This class is for all the log in the console related methods
class Logger {
  ///this constructor is for ensuring Nobody can create any object of this class
  Logger._();

  ///this works similar to log, one advantage you don't need to pass String always here
  ///you can send anything, it will call .toString() and log what you want
  static info(dynamic data, {required String tag}) {
    log('$data', name: tag);
  }
}
