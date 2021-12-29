import 'package:app_get/models/config_body.dart';
import 'package:get/get.dart';

class ConfigDialogController extends GetxController {
  Rx<ConfigBody> configBody = ConfigBody().obs;

  int? getValueForParameter({required ParameterType parameter}) {
    switch (parameter) {
      case ParameterType.initialTime:
        return configBody.value.initialTime;

      case ParameterType.finalTime:
        return configBody.value.finalTime;

      case ParameterType.initialTemp:
        return configBody.value.initialTemp;

      case ParameterType.finalTemp:
        return configBody.value.finalTemp;

      default:
        return 0;
    }
  }

  String getButtonText({required ParameterType parameter}) {
    int? value = getValueForParameter(parameter: parameter);

    switch (parameter) {
      case ParameterType.initialTime:
      case ParameterType.finalTime:
        return value.toString().padLeft(2, '0') + ':00';
      case ParameterType.initialTemp:
      case ParameterType.finalTemp:
        return value.toString() + '.00°C';
      default:
        return 'Error';
    }
  }
}
