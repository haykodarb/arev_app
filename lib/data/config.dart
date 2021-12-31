import 'package:http/http.dart' as http;

class ConfigDataBackend {
  static Future<bool> acceptButtonHandler({
    required String ipAddress,
    required String jsonBody,
  }) async {
    final Uri urlToPost = Uri.http(ipAddress, '/config/set');

    http.Response response = await http.post(
      urlToPost,
      body: jsonBody,
    );

    return response.statusCode == 200;
  }

  static Future<String> getCurrentValues({
    required String ipAddress,
  }) async {
    final Uri urlToGet = Uri.http(ipAddress, '/config/get');
    http.Response response = await http.get(urlToGet);

    return response.body;
  }
}
