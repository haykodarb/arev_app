import 'package:app_get/models/config_body.dart';
import 'package:app_get/pages/config/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfigPage extends StatelessWidget {
  ConfigPage({Key? key}) : super(key: key);

  final ConfigController configController = ConfigController();

  Widget _confirmButtons() {
    final BuildContext context = Get.context!;
    return Container(
      margin: const EdgeInsets.only(
        bottom: 30,
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          OutlinedButton(
            onPressed: configController.onCancelButtonPressed,
            style: OutlinedButton.styleFrom(
              fixedSize: const Size(140, 60),
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 20,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: configController.onAcceptButtonPressed,
            style: ElevatedButton.styleFrom(
              elevation: 20,
              fixedSize: const Size(140, 60),
            ),
            child: Text(
              'Aceptar',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _configButton(ParameterType parameter) {
    final BuildContext context = Get.context!;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.onBackground,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            configController.configBody.value.getButtonTitle(
              parameter: parameter,
            ),
            style: TextStyle(
              fontSize: 22,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          Obx(
            () {
              final String value =
                  configController.configBody.value.getButtonText(
                parameter: parameter,
              );

              final bool isOn = configController.configBody.value.systState;

              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: Theme.of(context).colorScheme.copyWith(
                        secondary: Theme.of(context).colorScheme.primary,
                      ),
                ),
                child: OutlinedButton(
                  onPressed: () =>
                      configController.getCallbackForParameter(parameter),
                  style: OutlinedButton.styleFrom(
                    shadowColor: isOn
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.error,
                    side: BorderSide(
                      color: isOn
                          ? Theme.of(context).colorScheme.surface
                          : Theme.of(context).colorScheme.error,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    value,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 22,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _systButton() {
    final BuildContext context = Get.context!;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.onBackground,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Sistema',
            style: TextStyle(
              fontSize: 22,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          Obx(
            () {
              final bool isOn = configController.configBody.value.systState;
              return ElevatedButton(
                onPressed: configController.onSystButtonPressed,
                style: ElevatedButton.styleFrom(
                  primary: isOn
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).colorScheme.error,
                  fixedSize: const Size(120, 60),
                ),
                child: Text(
                  isOn ? 'ON' : 'OFF',
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _selectedTimeShow() {
    BuildContext context = Get.context!;
    int initTime = configController.configBody.value.initialTime;
    int finalTime = configController.configBody.value.finalTime;
    String text =
        'Encendido desde las $initTime:00 hasta las $finalTime:00 del ';
    text += initTime > finalTime ? 'día siguiente.' : 'mismo día.';
    text = initTime == finalTime ? 'Encendido todo el día.' : text;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.onBackground,
            width: 0.5,
          ),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 18,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: configController,
      builder: (ConfigController controller) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Configurar',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).colorScheme.primary,
            elevation: 20,
          ),
          body: Obx(
            () {
              return configController.isLoaded.value
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        _systButton(),
                        _configButton(ParameterType.initialTime),
                        _configButton(ParameterType.finalTime),
                        _selectedTimeShow(),
                        _configButton(ParameterType.initialTemp),
                        _configButton(ParameterType.finalTemp),
                        Expanded(
                          child: _confirmButtons(),
                        ),
                      ],
                    )
                  : const Center(
                      child: SizedBox(
                        height: 400,
                        width: 350,
                        child: Center(
                          child: SizedBox(
                            height: 70,
                            width: 70,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              strokeWidth: 7.0,
                            ),
                          ),
                        ),
                      ),
                    );
            },
          ),
        );
      },
    );
  }
}
