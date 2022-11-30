abstract class ILocalStorage {
  ///This will write a bool in the local storage(K,V pairs)
  Future<bool> writeBool(String key, bool value);

  ///This will write a int in the local storage(K,V pairs)
  Future<bool> writeInt(String key, int value);

  ///This will write a double in the local storage(K,V pairs)
  Future<bool> writeDouble(String key, double value);

  ///This will write a String in the local storage(K,V pairs)
  Future<bool> writeString(String key, String value);

  ///This will write a List<String> in the local storage(K,V pairs)
  Future<bool> writeStringList(String key, List<String> value);

  ///This will read a bool in the local storage by the key
  bool? readBool(String key);

  ///This will read a int in the local storage by the key
  int? readInt(String key);

  ///This will read a double in the local storage by the key
  double? readDouble(String key);

  ///This will read a String in the local storage by the key
  String? readString(String key);

  ///This will read a List<String> in the local storage by the key
  List<String>? readStringList(String key);

  ///This will delete a value in the local storage by the key
  Future<bool> delete(String key);
}
