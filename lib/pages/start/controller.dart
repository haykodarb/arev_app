import 'package:app_get/data/device_name.dart';
import 'package:app_get/data/device_power.dart';
import 'package:app_get/data/zeroconf.dart';
import 'package:app_get/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_get/models/zeroconf.dart';

class StartPageController extends GetxController {
  RxList<ZeroconfService> foundDevices = <ZeroconfService>[].obs;

  final DevicePowerBackend devicePowerBackend = DevicePowerBackend();
  final DeviceNameBackend deviceNameBackend = DeviceNameBackend();

  @override
  void onInit() {
    findDevices();
    super.onInit();
  }

  void onDeviceItemPressed({
    required ZeroconfService currentDevice,
  }) {
    if (currentDevice.isPowerSet) {
      Get.toNamed<dynamic>(
        RouteNames.devicePage,
        arguments: <String, ZeroconfService>{
          'currentDevice': currentDevice,
        },
      );
    } else {
      openConfigDialog(
        currentDevice: currentDevice,
      );
    }
  }

  Future<void> _postValues({
    required int power,
    required String name,
    required ZeroconfService currentDevice,
  }) async {
    try {
      final bool powerSuccess = await devicePowerBackend.storeDevicePower(
        power: power,
        currentDevice: currentDevice,
      );

      /* TODO ADD THIS, HAVE TO DEBUG IN FIRMWARE

      final bool nameSuccess = await deviceNameBackend.postDeviceName(
        newName: name,
        currentDevice: currentDevice,
      );
      
      */

      if (powerSuccess) {
        currentDevice.isPowerSet = true;
        currentDevice.power = power;
        Get.toNamed<dynamic>(
          RouteNames.devicePage,
          arguments: <String, ZeroconfService>{
            'currentDevice': currentDevice,
          },
        );
      }
    } catch (e) {
      return;
    }
  }

  void openConfigDialog({
    required ZeroconfService currentDevice,
  }) {
    Widget _dialogForm() {
      RxString name = currentDevice.deviceName.obs;
      RxInt power = currentDevice.power.obs;
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextFormField(
            initialValue: name.value,
            decoration: const InputDecoration(
              labelText: 'Nombre',
            ),
            validator: (String? newValue) {
              if (newValue == null || newValue.isEmpty) {
                return 'Ingrese un nombre';
              } else {
                return null;
              }
            },
            autovalidateMode: AutovalidateMode.always,
            style: const TextStyle(
              fontSize: 18,
            ),
            obscureText: false,
            keyboardType: TextInputType.name,
            onChanged: (String newName) {
              name.value = newName;
            },
            maxLength: 20,
          ),
          TextFormField(
            initialValue: power.toString(),
            decoration: const InputDecoration(
              labelText: 'Potencia [W]',
            ),
            style: const TextStyle(
              fontSize: 18,
            ),
            keyboardType: TextInputType.number,
            obscureText: false,
            maxLength: 5,
            onChanged: (String newPower) {
              power.value = int.tryParse(newPower)!;
            },
          ),
          Row(
            children: [
              TextButton(
                child: const Text('ACEPTAR'),
                onPressed: () {
                  _postValues(
                    power: power.value,
                    name: name.value,
                    currentDevice: currentDevice,
                  );
                  Get.back<dynamic>();
                },
              ),
              TextButton(
                child: const Text('CANCELAR'),
                onPressed: () {
                  Get.back<dynamic>();
                },
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
        ],
      );
    }

    BuildContext? context = Get.context;

    Get.dialog<dynamic>(
      Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 300,
          ),
          child: Container(
            child: _dialogForm(),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context!).colorScheme.background,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
    );
  }

  void emptyDevices() {
    foundDevices.value = [];
  }

  void addDevice({
    required ZeroconfService newDevice,
  }) {
    foundDevices.addIf(
      !foundDevices.any(
        (item) => item.deviceName == newDevice.deviceName,
      ),
      newDevice,
    );
  }

  Future<void> findDevices() async {
    emptyDevices();

    ZeroconfBackend().scanZeroconfDevices(addDevice: addDevice);
  }
}
