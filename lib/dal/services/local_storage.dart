import 'package:shared_preferences/shared_preferences.dart';

import 'interfaces/i_local_storage.dart';

class LocalStorage implements ILocalStorage {
  static final LocalStorage instance = LocalStorage._();
  static late final SharedPreferences _prefs;

  LocalStorage._();

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  bool? readBool(String key) {
    return _prefs.getBool(key);
  }

  @override
  double? readDouble(String key) {
    return _prefs.getDouble(key);
  }

  @override
  int? readInt(String key) {
    return _prefs.getInt(key);
  }

  @override
  String? readString(String key) {
    return _prefs.getString(key);
  }

  @override
  List<String>? readStringList(String key) {
    return _prefs.getStringList(key);
  }

  @override
  Future<bool> writeBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  @override
  Future<bool> writeDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  @override
  Future<bool> writeInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  @override
  Future<bool> writeString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  @override
  Future<bool> writeStringList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  @override
  Future<bool> delete(String key) async {
    return await _prefs.remove(key);
  }
}
