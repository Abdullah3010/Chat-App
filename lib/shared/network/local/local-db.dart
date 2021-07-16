import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  static late SharedPreferences sharedPreferences;

  static int() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> putData({
    required String key,
    required dynamic value,
  }) async {
    if (value is bool) return await sharedPreferences.setBool(key, value);
    if (value is String) return await sharedPreferences.setString(key, value);
    if (value is double) return await sharedPreferences.setDouble(key, value);
    return await sharedPreferences.setInt(key, value);
  }

  static String? getString({
    required String key,
  }) {
    return sharedPreferences.getString(key);
  }

  static removeData({
    required String key,
  }) async {
    return await sharedPreferences.remove(key);
  }

  static clear() async => await sharedPreferences.clear();
}
