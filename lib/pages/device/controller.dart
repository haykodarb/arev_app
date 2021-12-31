import 'package:app_get/data/websocket.dart';
import 'package:app_get/models/zeroconf.dart';
import 'package:app_get/routes.dart';
import 'package:get/get.dart';

class DevicePageController extends GetxController {
  final ZeroconfService currentDevice =
      Get.arguments['currentDevice'] as ZeroconfService;

  final RxInt bottomNavigationBarIndex = 0.obs;

  final WebSocketBackend webSocketBackend = WebSocketBackend();

  void onBottomNavigationItemTap(int index) {
    switch (index) {
      case 0:
      case 1:
        bottomNavigationBarIndex.value = index;
        break;
      case 2:
        onConfigButtonPressed();
        break;
      default:
    }
  }

  Future<void> onConfigButtonPressed() async {
    Get.toNamed<dynamic>(
      RouteNames.configPage,
      arguments: <String, ZeroconfService>{
        'currentDevice': currentDevice,
      },
    );
  }

  Stream<dynamic> createWebSocketStream() {
    final Stream<dynamic> stream = webSocketBackend.createWebSocketStream(
      ipAddress: currentDevice.ipAddress,
    );

    return stream;
  }
}
