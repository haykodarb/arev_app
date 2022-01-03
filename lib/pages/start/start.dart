import 'package:app_get/models/zeroconf.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_get/pages/start/controller.dart';
import 'package:google_fonts/google_fonts.dart';

class StartPage extends StatelessWidget {
  StartPage({Key? key}) : super(key: key);

  final StartPageController startPageController = StartPageController();

  Widget _brandLogo({
    required BuildContext context,
  }) {
    return Container(
      child: Padding(
        child: Text(
          'Arev',
          style: GoogleFonts.patuaOne(
            fontSize: 80,
            color: Colors.white,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(70, 30, 70, 30),
      ),
      margin: const EdgeInsets.only(
        top: 50,
      ),
      alignment: Alignment.center,
    );
  }

  Widget _deviceListTitle({
    required BuildContext context,
  }) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Dispositivos encontrados',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          IconButton(
            onPressed: startPageController.findDevices,
            icon: const Icon(
              Icons.replay_outlined,
              size: 30,
            ),
          ),
        ],
      ),
      margin: const EdgeInsets.only(
        top: 30,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ),
      alignment: Alignment.center,
      height: 50,
      width: 700,
    );
  }

  Widget _deviceSelectButton({
    required ZeroconfService currentDevice,
    required BoxConstraints constraints,
  }) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(constraints.maxWidth, 75),
          elevation: 20,
        ),
        child: Text(
          currentDevice.deviceName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
          ),
        ),
        onPressed: () {
          startPageController.onDeviceItemPressed(
            currentDevice: currentDevice,
          );
        },
      ),
    );
  }

  Widget _deviceSettingsButtons({
    required ZeroconfService currentDevice,
  }) {
    final context = Get.context!;
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                right: 5,
              ),
              child: OutlinedButton(
                onPressed: () {
                  startPageController.openConfigDialog(
                    currentDevice: currentDevice,
                  );
                },
                child: const Icon(
                  Icons.settings_outlined,
                  color: Colors.white,
                  size: 40,
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                left: 5,
              ),
              child: OutlinedButton(
                onPressed: () {
                  startPageController.openDateDialog(
                    currentDevice: currentDevice,
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: const Icon(
                  Icons.date_range_outlined,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _deviceItem({
    required ZeroconfService currentDevice,
  }) {
    return LayoutBuilder(builder: (
      context,
      constraints,
    ) {
      return Container(
        margin: const EdgeInsets.only(
          top: 20,
        ),
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _deviceSelectButton(
              constraints: constraints,
              currentDevice: currentDevice,
            ),
            _deviceSettingsButtons(
              currentDevice: currentDevice,
            ),
          ],
        ),
      );
    });
  }

  Widget _deviceList({
    required List<ZeroconfService> foundDevices,
  }) {
    return Flexible(
      child: SizedBox(
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: foundDevices.length,
          itemBuilder: (BuildContext context, int index) {
            return _deviceItem(
              currentDevice: foundDevices[index],
            );
          },
        ),
        width: 300,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: startPageController,
      builder: (StartPageController controller) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _brandLogo(
                  context: context,
                ),
                _deviceListTitle(
                  context: context,
                ),
                Obx(
                  () => _deviceList(
                    foundDevices: controller.foundDevices,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
