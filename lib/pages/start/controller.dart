// ignore_for_file: use_build_context_synchronously

import 'package:app_get/data/device_config.dart';
import 'package:app_get/data/zeroconf.dart';
import 'package:app_get/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_get/models/zeroconf.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class StartPageController extends GetxController {
  RxList<ZeroconfService> foundDevices = <ZeroconfService>[].obs;

  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    findDevices();
  }

  void onDeviceItemPressed({
    required ZeroconfService currentDevice,
  }) {
    Get.toNamed<dynamic>(
      RouteNames.devicePage,
      arguments: <String, ZeroconfService>{
        'currentDevice': currentDevice,
      },
    );
  }

  Future<void> _postValues({
    required int power,
    required String name,
    required ZeroconfService currentDevice,
  }) async {
    try {
      final bool powerSuccess = await DeviceConfigBackend.postDevicePower(
        power: power,
        currentDevice: currentDevice,
      );

      final bool nameSuccess = await DeviceConfigBackend.postDeviceName(
        newName: name,
        currentDevice: currentDevice,
      );
      if (powerSuccess) {
        currentDevice.power = power;
      }

      if (nameSuccess) {
        Future.delayed(
          const Duration(milliseconds: 100),
          findDevices,
        );
      }
    } catch (e) {
      return;
    }
  }

  Future<String> _getDeviceTime({
    required ZeroconfService currentDevice,
  }) async {
    final int secondsSinceEpoch = await DeviceConfigBackend.getDeviceUnixTime(
        ipAddress: currentDevice.ipAddress);

    final DateFormat dateFormat = DateFormat('MM/dd/yyyy hh:mm:ss a');

    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(secondsSinceEpoch * 1000).toUtc();

    return dateFormat.format(dateTime);
  }

  Future<void> openDateDialog({
    required ZeroconfService currentDevice,
  }) async {
    final context = Get.context!;

    String date = await _getDeviceTime(currentDevice: currentDevice);

    Widget _dialogForm() {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'La fecha actual del dispositivo es: ',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              date,
              textAlign: TextAlign.center,
            ),
            Text(
              '¿Deseas corregirla?',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              'Esto va a fijar la hora y fecha del dispositivo según los valores actuales de tu telefono.',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w300,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 40,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: const Text('CANCELAR'),
                    onPressed: () {
                      Get.back<dynamic>();
                    },
                  ),
                  TextButton(
                    child: const Text('SI, AJUSTAR'),
                    onPressed: () async {
                      final bool success =
                          await DeviceConfigBackend.setDeviceUnixTime(
                        currentDevice: currentDevice,
                      );
                      if (success) {
                        Get.back<dynamic>();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Get.dialog<dynamic>(
      Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 400,
          ),
          child: Container(
            height: double.maxFinite,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: _dialogForm(),
          ),
        ),
      ),
    );
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
              fontSize: 22,
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
              fontSize: 22,
            ),
            keyboardType: TextInputType.number,
            obscureText: false,
            maxLength: 5,
            onChanged: (String newPower) {
              power.value = int.tryParse(newPower)!;
            },
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 40,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: const Text('CANCELAR'),
                  onPressed: () {
                    Get.back<dynamic>();
                  },
                ),
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
              ],
            ),
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
            maxHeight: 400,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context!).colorScheme.background,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: _dialogForm(),
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
    if (isLoading.value) {
      isLoading.value = false;
    }

    foundDevices.addIf(
      !foundDevices.any(
        (item) => item.ipAddress == newDevice.ipAddress,
      ),
      newDevice,
    );
  }

  Future<void> findDevices() async {
    emptyDevices();
    isLoading.value = true;
    await ZeroconfBackend.scanZeroconfDevices(addDevice: addDevice);
  }
}
