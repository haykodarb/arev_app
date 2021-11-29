import 'package:app_get/models/zeroconf.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DevicePowerBackend {
  Future<bool> storeDevicePower({
    required int power,
    required ZeroconfService currentDevice,
  }) async {
    if (power != currentDevice.power) {
      try {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        final bool success = await prefs.setInt(
          currentDevice.deviceID,
          power,
        );

        currentDevice.power = power;

        currentDevice.isPowerSet = true;

        return success;
      } catch (e) {
        return false;
      }
    }

    return false;
  }

  Future<int?> getDevicePower({required ZeroconfService currentDevice}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (await isDevicePowerSet(currentDevice: currentDevice)) {
        return prefs.getInt(currentDevice.deviceID);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> isDevicePowerSet(
      {required ZeroconfService currentDevice}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(currentDevice.deviceID);
    } catch (e) {
      return false;
    }
  }
}
