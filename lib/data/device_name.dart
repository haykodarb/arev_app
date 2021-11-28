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

      print(currentDevice.ipAddress);
      final Uri uri = Uri.http(currentDevice.ipAddress, '/name', queryParams);

      try {
        final http.Response response = await http.get(uri);
        print('Response: ${response.statusCode}');

        if (response.body.isNotEmpty) {
          return true;
        } else {
          return false;
        }
      } catch (e) {
        print(e);
        return false;
      }
    }

    return true;
  }
}
