import 'dart:convert';

import 'package:app_get/models/zeroconf.dart';
import 'package:http/http.dart' as http;

class DeviceConfigBackend {
  static Future<bool> postDeviceName({
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

    return false;
  }

  static Future<bool> postDevicePower({
    required int power,
    required ZeroconfService currentDevice,
  }) async {
    if (power != currentDevice.power) {
      Map<String, String> queryParams = {
        'new': power.toString(),
      };

      final Uri uri = Uri.http(
        currentDevice.ipAddress,
        '/power/set',
        queryParams,
      );

      final http.Response response = await http.get(uri);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }

    return false;
  }

  static Future<int> getDevicePower({
    required String ipAddress,
  }) async {
    final Uri uri = Uri.http(
      ipAddress,
      '/power/get',
    );

    try {
      final http.Response response = await http.get(uri);

      if (response.body.isNotEmpty) {
        dynamic parsedBody = jsonDecode(response.body)!;

        return parsedBody['power'] as int;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  static Future<int> getDeviceUnixTime({
    required String ipAddress,
  }) async {
    final Uri uri = Uri.http(
      ipAddress,
      '/time/get',
    );

    try {
      final http.Response response = await http.get(uri);

      if (response.body.isNotEmpty) {
        dynamic parsedBody = jsonDecode(response.body)!;

        return int.tryParse(parsedBody['time']! as String)!;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  static Future<bool> setDeviceUnixTime({
    required ZeroconfService currentDevice,
  }) async {
    int currentTimeInSeconds = (DateTime.now().millisecondsSinceEpoch / 1000 +
            DateTime.now().timeZoneOffset.inSeconds)
        .floor();

    Map<String, String> queryParams = {
      'new': currentTimeInSeconds.toString(),
    };

    final Uri uri = Uri.http(
      currentDevice.ipAddress,
      '/time/set',
      queryParams,
    );

    final http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
