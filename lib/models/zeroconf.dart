class ZeroconfService {
  String ipAddress;
  String deviceName;
  String deviceID;
  int power = 1000;
  bool isPowerSet = false;
  ZeroconfService({
    required this.deviceName,
    required this.ipAddress,
    required this.deviceID,
  });
}
