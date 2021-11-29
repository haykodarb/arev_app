import 'package:http/http.dart' as http;
import 'package:date_format/date_format.dart';

class GraphBackend {
  Future<String?> getMonthData({
    required String url,
    required bool isDay,
    required DateTime selectedDate,
  }) async {
    Uri urlToGet;
    if (isDay) {
      final String dateFormatted = formatDate(
        selectedDate,
        [yyyy, mm, dd],
      );
      Map<String, String> request = {
        'file': dateFormatted,
      };
      urlToGet = Uri.http(url, '/files/day', request);
    } else {
      final String dateFormatted = formatDate(
        selectedDate,
        [yyyy, mm],
      );

      Map<String, String> request = {
        'file': dateFormatted,
      };

      urlToGet = Uri.http(url, '/files/month', request);
    }
    try {
      final http.Response httpResponse = await http.get(urlToGet);
      return httpResponse.body;
    } catch (e) {
      rethrow;
    }
  }
}
