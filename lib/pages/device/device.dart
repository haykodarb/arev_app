import 'package:app_get/pages/device/controller.dart';
import 'package:app_get/pages/graph/graph.dart';
import 'package:app_get/pages/status/status.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DevicePage extends StatelessWidget {
  const DevicePage({Key? key}) : super(key: key);

  Widget bottomNavigationBar({
    required BuildContext context,
    required DevicePageController controller,
  }) {
    return Obx(
      () => BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onTap: controller.onBottomNavigationItemTap,
        currentIndex: controller.bottomNavigationBarIndex.value,
        selectedItemColor: Theme.of(context).colorScheme.onPrimary,
        unselectedItemColor: Theme.of(context).colorScheme.background,
        unselectedFontSize: 15,
        selectedFontSize: 15,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'Estado',
            icon: Icon(
              Icons.tungsten,
              size: 30,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Consumo',
            icon: Icon(
              Icons.bar_chart,
              size: 30,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Configurar',
            icon: Icon(
              Icons.settings,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appBar({
    required BuildContext context,
    required DevicePageController controller,
  }) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(controller.currentDevice.deviceName),
      elevation: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: DevicePageController(),
      builder: (DevicePageController controller) {
        return Obx(
          () {
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              bottomNavigationBar: bottomNavigationBar(
                context: context,
                controller: controller,
              ),
              appBar: _appBar(
                context: context,
                controller: controller,
              ),
              body: controller.bottomNavigationBarIndex.value == 0
                  ? StatusPage()
                  : const GraphPage(),
            );
          },
        );
      },
    );
  }
}
