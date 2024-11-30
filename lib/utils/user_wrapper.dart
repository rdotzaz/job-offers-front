import 'package:oferty_pracy/utils/hive_adapter.dart';

class UserWrapper {
  static void addApiKey(String apiKey) => HiveDatabaseAdapter.putApiKey(apiKey);
  static bool isLoggedIn() => HiveDatabaseAdapter.isUserLoggedIn();
  static String get key => HiveDatabaseAdapter.getApiKey();
  static Map<String, String> toQueryMap() => {"apiKey": key};
}
