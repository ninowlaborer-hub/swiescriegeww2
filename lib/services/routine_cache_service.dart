import 'package:shared_preferences/shared_preferences.dart';

class RoutineCacheService {
  static Future<void> cacheRoutineState(String stateToken) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString("SavedRoutine", stateToken);
  }

  static Future<String?> getCachedRoutineState() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    return storage.getString("SavedRoutine");
  }

  static Future<void> setRoutineEngineStatus(int status) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setInt("IsPermitted", status);
  }
}
