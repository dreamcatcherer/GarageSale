import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static SharedPreferences preferences;
  static Future<bool> getInstance() async {
    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    }
    return true;
  }

  static Future saveString(String key, String value) async {
    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    }
    preferences.setString(key, value);
  }

  static String getString(key) {
    if (preferences == null) return null;
    return preferences.getString(key);
  }

  static setStringList(String key, List list) async {
    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    }
    preferences.setStringList(key, list);
  }

  static List<String> getStringList(String key) {
    return preferences.getStringList(key);
  }

  static Future saveInt(String key, int value) async {
    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    }
    preferences.setInt(key, value);
  }

  static int getInt(key) {
    if (preferences == null) return null;
    return preferences.getInt(key);
  }

  // 清除数据
  static Future deleteUserInfo(String key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove(key);
  }
}
