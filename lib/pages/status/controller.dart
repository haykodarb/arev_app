import 'package:app_get/data/websocket.dart';
import 'package:app_get/models/zeroconf.dart';
import 'package:app_get/routes.dart';
import 'package:get/get.dart';

class StatusPageController extends GetxController {
  final ZeroconfService currentDevice =
      Get.arguments['currentDevice'] as ZeroconfService;

  final RxInt bottomNavigationBarIndex = 0.obs;

  final WebSocketBackend webSocketBackend = WebSocketBackend();

  void onBottomNavigationItemTap(int index) {
    bottomNavigationBarIndex.value = index;
  }

  Stream<dynamic> createWebSocketStream() {
    final Stream<dynamic> stream = webSocketBackend.createWebSocketStream(
      ipAddress: currentDevice.ipAddress,
    );
    return stream;
  }

  Future<void> onConfigButtonPressed() async {
    Get.toNamed<dynamic>(
      RouteNames.configPage,
      arguments: <String, ZeroconfService>{
        'currentDevice': currentDevice,
      },
    );
  }

  @override
  void onClose() {
    webSocketBackend.closeWebSocketStream();
    super.onClose();
  }
}
