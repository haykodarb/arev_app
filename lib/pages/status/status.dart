import 'package:app_get/pages/common/data_item.dart';
import 'package:app_get/pages/config/config.dart';
import 'package:app_get/pages/status/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import 'package:google_fonts/google_fonts.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({Key? key}) : super(key: key);

  Widget _temperatureIndicator({
    required double temperature,
  }) {
    return Expanded(
      child: TweenAnimationBuilder(
        tween: Tween<double>(
          begin: 0,
          end: temperature,
        ),
        duration: const Duration(
          seconds: 1,
          milliseconds: 500,
        ),
        curve: Curves.easeOut,
        builder: (context, double value, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                height: constraints.maxHeight * 0.8,
                width: constraints.maxHeight * 0.8,
                child: Stack(
                  children: [
                    Align(
                      alignment: const Alignment(0, 0),
                      child: ShaderMask(
                        shaderCallback: (rect) {
                          return SweepGradient(
                            startAngle: 0 * math.pi,
                            endAngle: 2 * math.pi,
                            transform: const GradientRotation(1.5 * math.pi),
                            tileMode: TileMode.decal,
                            stops: [
                              0,
                              value / 100 * 0.5,
                              value / 100 * 0.8,
                              value / 100,
                              1,
                            ],
                            center: Alignment.center,
                            colors: [
                              Colors.blue,
                              Colors.purple,
                              Colors.red,
                              Colors.red.withOpacity(0.1),
                              Colors.red.withOpacity(0.1),
                            ],
                          ).createShader(rect);
                        },
                        child: Container(
                          height: constraints.maxHeight * 0.8,
                          width: constraints.maxHeight * 0.8,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: Image.asset(
                                'assets/radial_scale.png',
                              ).image,
                              fit: BoxFit.cover,
                              alignment: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 200,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.background,
                        ),
                        child: Center(
                          child: Text(
                            '${temperature.toStringAsFixed(2)}º',
                            style: GoogleFonts.coda(
                              fontSize: 50,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _webSocketData({
    required BuildContext context,
    required StatusPageController controller,
  }) {
    return StreamBuilder<dynamic>(
      stream: controller.createWebSocketStream(),
      builder: (context, snapshot) {
        final List<String> dataList = snapshot.data.toString().split(',');

        if (snapshot.hasData) {
          final double temperature = double.tryParse(dataList[1])!;
          return ConstrainedBox(
            constraints: BoxConstraints.loose(
              const Size(
                double.maxFinite,
                550,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _temperatureIndicator(
                  temperature: temperature,
                ),
                DataItem(
                  itemTitle: 'Sistema',
                  itemData: dataList[3] == '1' ? 'ON' : 'OFF',
                  isLong: false,
                ),
                DataItem(
                  itemTitle: 'Resistencia',
                  itemData: dataList[2] == '1' ? 'ON' : 'OFF',
                  isLong: false,
                ),
                DataItem(
                  itemTitle: 'Fecha',
                  itemData: '${dataList[0]}  -  28/11/2021',
                  isLong: true,
                ),
              ],
            ),
          );
        } else {
          return const SizedBox(
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
          );
        }
      },
    );
  }

  Widget _configButtons({
    required BuildContext context,
    required StatusPageController controller,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: TextButton(
              onPressed: () {
                Get.dialog<ConfigDialog>(
                  const ConfigDialog(),
                );
              },
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 60,
                ),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
                  child: Text(
                    'Configurar',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: TextButton(
              onPressed: () {},
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 60,
                ),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
                  child: Text(
                    'Ajustar fecha',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: StatusPageController(),
      builder: (StatusPageController controller) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: _webSocketData(
                context: context,
                controller: controller,
              ),
            ),
            _configButtons(
              context: context,
              controller: controller,
            ),
          ],
        );
      },
    );
  }
}
