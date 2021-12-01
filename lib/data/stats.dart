import 'package:http/http.dart' as http;
import 'package:date_format/date_format.dart';

class GraphBackend {
  static Future<String?> getDayData({
    required String url,
    required DateTime selectedDate,
  }) async {
    final String dateFormatted = formatDate(
      selectedDate,
      [yyyy, mm, dd],
    );

    final Map<String, String> request = {
      'file': dateFormatted,
    };

    final Uri urlToGet = Uri.http(url, '/files/day', request);

    try {
      final http.Response httpResponse = await http.get(urlToGet);
      return httpResponse.body;
    } catch (e) {
      rethrow;
    }
  }

  static Future<String?> getMonthData({
    required String url,
    required DateTime selectedDate,
  }) async {
    final String dateFormatted = formatDate(
      selectedDate,
      [yyyy, mm],
    );

    final Map<String, String> request = {
      'file': dateFormatted,
    };

    final urlToGet = Uri.http(url, '/files/month', request);

    try {
      final http.Response httpResponse = await http.get(urlToGet);
      return httpResponse.body;
    } catch (e) {
      rethrow;
    }
  }
}
