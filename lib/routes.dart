import 'package:app_get/pages/config/config.dart';
import 'package:app_get/pages/device/device.dart';
import 'package:get/get.dart';
import 'package:app_get/pages/start/start.dart';

class RouteNames {
  static const startPage = '/start';
  static const devicePage = '/device';
  static const configPage = '/config';
}

List<GetPage> routes() => <GetPage>[
      GetPage<dynamic>(
        name: RouteNames.startPage,
        page: () => StartPage(),
      ),
      GetPage<dynamic>(
        name: RouteNames.devicePage,
        page: () => const DevicePage(),
        transition: Transition.downToUp,
      ),
      GetPage<dynamic>(
        name: RouteNames.configPage,
        page: () => ConfigPage(),
        transition: Transition.rightToLeft,
      ),
    ];
