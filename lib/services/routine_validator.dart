import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class RoutineValidator {
  static Future<bool> isRoutineEngineReady() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return !connectivityResult.contains(ConnectivityResult.none);
  }

  static Future<http.Response> validateRoutineSource(bool scanDeep, String source) async {
    if (scanDeep) {
      return await http.get(Uri.parse(source));
    } else {
      return await http.head(Uri.parse(source));
    }
  }
}
