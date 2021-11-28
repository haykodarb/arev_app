import 'package:app_get/models/zeroconf.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_get/pages/start/controller.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  Widget _brandLogo({
    required BuildContext context,
  }) {
    return Container(
      child: Padding(
        child: Text(
          'Arev.',
          style: Theme.of(context).textTheme.headline1,
        ),
        padding: const EdgeInsets.fromLTRB(70, 30, 70, 30),
      ),
      margin: const EdgeInsets.only(
        top: 50,
      ),
      alignment: Alignment.center,
      width: 300,
      height: 150,
    );
  }

  Widget _deviceListTitle({
    required BuildContext context,
  }) {
    return Container(
      child: Text(
        'Dispositivos encontrados.',
        style: Theme.of(context).textTheme.subtitle1,
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

  Widget _deviceItem({
    required ZeroconfService currentDevice,
    required BuildContext context,
    required StartPageController controller,
  }) {
    return Container(
      child: MaterialButton(
        child: Container(
          child: Text(
            currentDevice.deviceName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.button,
          ),
          alignment: Alignment.center,
        ),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            5,
          ),
        ),
        color: Theme.of(context).colorScheme.primary,
        onPressed: () {
          controller.onDeviceItemPressed(
            currentDevice: currentDevice,
          );
        },
      ),
      margin: const EdgeInsets.only(
        top: 5,
        bottom: 5,
      ),
      height: 60,
    );
  }

  Widget _deviceList({
    required List<ZeroconfService> foundDevices,
    required StartPageController controller,
    required BuildContext context,
  }) {
    return Flexible(
      child: SizedBox(
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: foundDevices.length,
          itemBuilder: (BuildContext context, int index) {
            return _deviceItem(
              context: context,
              currentDevice: foundDevices[index],
              controller: controller,
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
      init: StartPageController(),
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
                    context: context,
                    foundDevices: controller.foundDevices,
                    controller: controller,
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
