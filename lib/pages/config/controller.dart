import 'package:app_get/data/config.dart';
import 'package:app_get/models/config_body.dart';
import 'package:app_get/models/zeroconf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:get/get.dart';

class ConfigController extends GetxController {
  Rx<ConfigBody> configBody = ConfigBody().obs;
  final ZeroconfService currentDevice =
      Get.arguments['currentDevice'] as ZeroconfService;
  final Rx<bool> isLoaded = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    final String jsonString = await ConfigDataBackend.getCurrentValues(
      ipAddress: currentDevice.ipAddress,
    );

    configBody(
      ConfigBody.fromJson(jsonString),
    );

    isLoaded.value = true;
  }

  void onSystButtonPressed() {
    configBody.update((val) {
      bool state = val!.systState;

      val.systState = !state;
    });
  }

  Future<void> onAcceptButtonPressed() async {
    await ConfigDataBackend.acceptButtonHandler(
      ipAddress: currentDevice.ipAddress,
      jsonBody: configBody.value.toJson(),
    );

    Get.back(
      result: true,
    );
  }

  void onCancelButtonPressed() {
    Get.back(result: true);
  }

  void onParameterValueChange({
    required ParameterType parameter,
    required int value,
  }) {
    switch (parameter) {
      case ParameterType.initialTime:
        configBody.update((val) {
          val!.initialTime = value;
        });
        break;
      case ParameterType.finalTime:
        configBody.update((val) {
          val!.finalTime = value;
        });
        break;
      case ParameterType.initialTemp:
        configBody.update((val) {
          val!.initialTemp = value;
        });
        break;
      case ParameterType.finalTemp:
        configBody.update((val) {
          val!.finalTemp = value;
        });
        break;
      default:
        return;
    }
  }

  void getCallbackForParameter(ParameterType parameter) {
    final BuildContext context = Get.context!;

    int minValue = 0;
    int maxValue = 0;
    int value = configBody.value.getValueForParameter(
      parameter: parameter,
    );

    String title = configBody.value.getButtonTitle(
      parameter: parameter,
    );

    switch (parameter) {
      case ParameterType.initialTime:
        minValue = 0;
        maxValue = configBody.value.finalTime - 1;
        break;
      case ParameterType.finalTime:
        minValue = configBody.value.initialTime + 1;
        maxValue = 23;
        break;

      case ParameterType.initialTemp:
        minValue = 1;
        maxValue = configBody.value.finalTemp - 1;
        break;

      case ParameterType.finalTemp:
        minValue = configBody.value.initialTemp + 1;
        maxValue = 80;
        break;

      default:
        return;
    }

    showMaterialNumberPicker(
        context: context,
        minNumber: minValue,
        maxNumber: maxValue,
        selectedNumber: value,
        title: title,
        buttonTextColor: Theme.of(context).colorScheme.onBackground,
        headerColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.background,
        headerTextColor: Theme.of(context).colorScheme.onPrimary,
        onChanged: (newValue) {
          onParameterValueChange(
            value: newValue,
            parameter: parameter,
          );
        });
  }
}
