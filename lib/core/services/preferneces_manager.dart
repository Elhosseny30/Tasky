import 'package:shared_preferences/shared_preferences.dart';

class PrefernecesManager {
  static final PrefernecesManager _instance = PrefernecesManager._internal();

  factory PrefernecesManager() {
    return _instance;
  }
  PrefernecesManager._internal();

  late final SharedPreferences _preferences;


  // initialization
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }


// set
  Future<bool> setString(String key, String value) {
    return _preferences.setString(key, value);
  }

  Future<bool> setInt(String key, int value) {
    return _preferences.setInt(key, value);
  }

  Future<bool> setDouble(String key, double value) {
    return _preferences.setDouble(key, value);
  }

  Future<bool> setBool(String key, bool value) {
    return _preferences.setBool(key, value);
  }

  Future<bool> setStringList(String key, List<String> value) {
    return _preferences.setStringList(key, value);
  }

  // get 
  String? getString(String key) {
    return _preferences.getString(key);
  }
  int? getInt(String key) {
    return _preferences.getInt(key);
  }
  double? getDouble(String key) {
    return _preferences.getDouble(key);
  }
  bool? getBool(String key) {
    return _preferences.getBool(key);
  }
  List<String>? getStringList(String key) {
    return _preferences.getStringList(key);
  }

  

  //delete
  Future<bool> remove(String key) {
    return _preferences.remove(key);
  }

  Future<bool> clear() {
    return _preferences.clear();
  }
}
