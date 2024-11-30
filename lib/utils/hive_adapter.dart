import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabaseAdapter {
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox("user");
  }

  static void clear() {
    final userBox = Hive.box("user");
    userBox.clear();
  }

  static bool isUserLoggedIn() {
    final userBox = Hive.box("user");
    if (!userBox.isOpen) {
      return false;
    }
    return userBox.get("apiKey") != null;
  }

  static void putApiKey(String apiKey) {
    final userBox = Hive.box("user");
    if (!userBox.isOpen) {
      return;
    }

    userBox.put("apiKey", apiKey);
  }

  static String getApiKey() {
    final userBox = Hive.box("user");
    if (!userBox.isOpen) {
      return "";
    }

    final apiKey = userBox.get("apiKey");
    return apiKey;
  }

  static void logout() {
    final userBox = Hive.box("user");
    if (!userBox.isOpen) {
      return;
    }
    userBox.put("apiKey", null);
  }
}
