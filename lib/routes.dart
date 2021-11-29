import 'package:app_get/pages/device/device.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:app_get/pages/start/start.dart';

class RouteNames {
  static const startPage = '/start';
  static const devicePage = '/device';
}

List<GetPage> routes() => <GetPage>[
      GetPage<dynamic>(
        name: RouteNames.startPage,
        page: () => const StartPage(),
      ),
      GetPage<dynamic>(
        name: RouteNames.devicePage,
        page: () => const DevicePage(),
      ),
    ];
