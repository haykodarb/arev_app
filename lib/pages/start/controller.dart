import 'dart:io';

import 'package:app_get/data/device_name.dart';
import 'package:app_get/data/device_power.dart';
import 'package:app_get/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_get/models/zeroconf.dart';
import 'package:multicast_dns/multicast_dns.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        RouteNames.dashboardPage,
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
      /* TODO ADD THIS
      final bool powerSuccess = await devicePowerBackend.storeDevicePower(
        power: power,
        currentDevice: currentDevice,
      );
      */

      final bool nameSuccess = await deviceNameBackend.postDeviceName(
        newName: name,
        currentDevice: currentDevice,
      );

      if (nameSuccess) {
        findDevices();
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

  Future<void> findDevices() async {
    emptyDevices();

    const String name = '_arev._tcp.local';

    final MDnsClient client = MDnsClient(
      rawDatagramSocketFactory: (dynamic host, int port,
          {bool? reuseAddress, bool? reusePort, int? ttl}) {
        return RawDatagramSocket.bind(
          host,
          port,
          reuseAddress: true,
          reusePort: false,
          ttl: ttl!,
        );
      },
    );

    await client.start();

    await for (final PtrResourceRecord ptr in client.lookup<PtrResourceRecord>(
      ResourceRecordQuery.serverPointer(
        name,
      ),
    )) {
      await for (final SrvResourceRecord srv
          in client.lookup<SrvResourceRecord>(
        ResourceRecordQuery.service(
          ptr.domainName,
        ),
      )) {
        await for (final IPAddressResourceRecord ip
            in client.lookup<IPAddressResourceRecord>(
          ResourceRecordQuery.addressIPv4(
            srv.target,
          ),
        )) {
          final String deviceName = srv.name.split('.')[0];

          final ZeroconfService service = ZeroconfService(
            deviceName: deviceName,
            ipAddress: ip.address.host,
            deviceID: srv.target,
          );

          try {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();

            if (prefs.containsKey(srv.target)) {
              final int? powerValue = prefs.getInt(srv.target);
              service.power = powerValue!;
              service.isPowerSet = true;
            }
          } catch (e) {
            rethrow;
          }

          foundDevices.addIf(
            !foundDevices.any(
              (item) => item.deviceName == service.deviceName,
            ),
            service,
          );
        }
      }
    }

    client.stop();
  }
}
