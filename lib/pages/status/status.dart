import 'package:app_get/pages/common/data_item.dart';
import 'package:app_get/pages/status/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import 'package:google_fonts/google_fonts.dart';

class StatusPage extends StatelessWidget {
  StatusPage({Key? key}) : super(key: key);

  final StatusPageController statusController = StatusPageController();

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
            builder: (context, firstConstraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: firstConstraints.maxWidth,
                  maxWidth: firstConstraints.maxHeight,
                ),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: LayoutBuilder(builder: (context, secondConstraints) {
                    return Stack(
                      children: [
                        Align(
                          alignment: const Alignment(0, 0),
                          child: ShaderMask(
                              shaderCallback: (rect) {
                                return SweepGradient(
                                  startAngle: 0 * math.pi,
                                  endAngle: 2 * math.pi,
                                  transform:
                                      const GradientRotation(1.5 * math.pi),
                                  tileMode: TileMode.decal,
                                  stops: [
                                    0,
                                    value / 100,
                                    value / 100,
                                    1,
                                  ],
                                  center: Alignment.center,
                                  colors: [
                                    Theme.of(context).colorScheme.primary,
                                    Theme.of(context).colorScheme.secondary,
                                    Colors.blueGrey.withOpacity(0.1),
                                    Colors.blueGrey.withOpacity(0.1),
                                  ],
                                ).createShader(rect);
                              },
                              child: Center(
                                child: Icon(
                                  CupertinoIcons.timelapse,
                                  size: secondConstraints.constrainWidth(),
                                ),
                              )),
                        ),
                        Center(
                          child: Text(
                            '${temperature.toStringAsFixed(2)}º',
                            style: GoogleFonts.coda(
                              fontSize:
                                  secondConstraints.constrainWidth() * 0.12,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        )
                      ],
                    );
                  }),
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
  }) {
    return StreamBuilder<dynamic>(
      stream: statusController.createWebSocketStream(),
      builder: (context, snapshot) {
        final List<String> dataList = snapshot.data.toString().split(',');

        if (snapshot.hasData) {
          final double temperature = double.tryParse(dataList[1])!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _temperatureIndicator(
                temperature: temperature,
              ),
              DataItem(
                itemTitle: 'Resistencia',
                itemData: dataList[2] == '1' ? 'ON' : 'OFF',
              )
            ],
          );
        } else {
          return const Center(
            child: SizedBox(
              height: 70,
              width: 70,
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                strokeWidth: 7.0,
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: statusController,
      builder: (StatusPageController controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: _webSocketData(
                  context: context,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
