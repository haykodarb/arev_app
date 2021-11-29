import 'package:app_get/models/zeroconf.dart';
import 'package:http/http.dart' as http;

class DeviceNameBackend {
  Future<bool> postDeviceName({
    required String newName,
    required ZeroconfService currentDevice,
  }) async {
    if (newName != currentDevice.deviceName) {
      Map<String, String> queryParams = {
        'new': newName,
      };

      final Uri uri = Uri.http(currentDevice.ipAddress, '/name', queryParams);

      try {
        final http.Response response = await http.get(uri);

        if (response.body.isNotEmpty) {
          return true;
        } else {
          return false;
        }
      } catch (e) {
        return false;
      }
    }

    return true;
  }
}
