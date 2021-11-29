import 'package:app_get/data/websocket.dart';
import 'package:app_get/models/zeroconf.dart';
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

  @override
  void onClose() {
    webSocketBackend.closeWebSocketStream();
    super.onClose();
  }
}
