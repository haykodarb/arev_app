import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:app_get/pages/start/start.dart';
import 'package:app_get/pages/dashboard/dashboard.dart';

class RouteNames {
  static const startPage = '/start';
  static const dashboardPage = '/dashboard';
}

List<GetPage> routes() => <GetPage>[
      GetPage<dynamic>(
        name: RouteNames.startPage,
        page: () => const StartPage(),
      ),
      GetPage<dynamic>(
        name: RouteNames.dashboardPage,
        page: () => const DashboardPage(),
      ),
    ];
