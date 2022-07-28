import 'dart:io';

import 'package:app_get/models/zeroconf.dart';
import 'package:multicast_dns/multicast_dns.dart';
import 'package:app_get/data/device_config.dart';

class ZeroconfBackend {
  static Future<void> scanZeroconfDevices(
      {required void Function({
        required ZeroconfService newDevice,
      })
          addDevice}) async {
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
        print(srv);

        await for (final IPAddressResourceRecord ip
            in client.lookup<IPAddressResourceRecord>(
          ResourceRecordQuery.addressIPv4(
            srv.target,
          ),
        )) {
          final String deviceName = srv.name.split('.')[0];

          try {
            final int power = await DeviceConfigBackend.getDevicePower(
              ipAddress: ip.address.host,
            );

            final ZeroconfService newDevice = ZeroconfService(
              deviceName: deviceName,
              ipAddress: ip.address.host,
              deviceID: srv.target,
              power: power,
            );

            addDevice(
              newDevice: newDevice,
            );
          } catch (e) {
            rethrow;
          }
        }
      }
    }
    client.stop();
  }
}
