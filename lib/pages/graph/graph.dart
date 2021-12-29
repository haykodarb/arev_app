import 'package:app_get/models/power_data.dart';
import 'package:app_get/pages/common/data_item.dart';
import 'package:app_get/pages/graph/day/day.dart';
import 'package:app_get/pages/graph/month/month.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_get/pages/graph/controller.dart';

class GraphPage extends StatelessWidget {
  const GraphPage({Key? key}) : super(key: key);

  Widget _dateSelectButton({
    required BuildContext context,
    required GraphPageController controller,
    required GraphType buttonType,
    required GraphType selectedType,
  }) {
    final Color primary = Theme.of(context).colorScheme.primary;
    final Color background = Theme.of(context).colorScheme.background;
    final Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    final DateTime date = controller.selectedDate.value;

    final bool isSelected = buttonType == selectedType;
    final String label = (buttonType == GraphType.day ? '${date.day}-' : '') +
        '${date.month}-${date.year}';

    return Expanded(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: isSelected
              ? null
              : Border.all(
                  color: primary,
                ),
          color: isSelected ? primary : background,
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            elevation: 20,
          ),
          child: Text(
            isSelected
                ? label
                : buttonType == GraphType.day
                    ? 'Día'
                    : 'Mes',
            style: TextStyle(
              color: isSelected ? onPrimary : primary,
              fontSize: 22,
            ),
          ),
          onPressed: buttonType == GraphType.day
              ? controller.dayButtonCallback
              : controller.monthButtonCallback,
        ),
      ),
    );
  }

  Widget _dateButtonsRow({
    required BuildContext context,
    required GraphPageController controller,
  }) {
    return Row(
      children: <Widget>[
        Obx(
          () {
            return _dateSelectButton(
              context: context,
              controller: controller,
              buttonType: GraphType.day,
              selectedType: controller.selectedType.value,
            );
          },
        ),
        Obx(
          () {
            return _dateSelectButton(
              context: context,
              controller: controller,
              buttonType: GraphType.month,
              selectedType: controller.selectedType.value,
            );
          },
        ),
      ],
    );
  }

  Widget _powerView({required PowerData powerData}) {
    return Column(
      children: [
        DataItem(
          itemData: '${powerData.powerConsumed.toStringAsFixed(2)}kWh',
          itemTitle: 'Consumo',
          isLong: true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: GraphPageController(),
      builder: (GraphPageController controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _dateButtonsRow(
                context: context,
                controller: controller,
              ),
              Obx(
                () {
                  return !controller.isGraphLoaded.value
                      ? const Expanded(
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
                        )
                      : Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            child: Obx(
                              () =>
                                  controller.selectedType.value == GraphType.day
                                      ? DayGraph(
                                          data: controller.dayGraphData,
                                        )
                                      : MonthGraph(
                                          data: controller.monthGraphData,
                                        ),
                            ),
                          ),
                        );
                },
              ),
              Obx(
                () => _powerView(powerData: controller.powerData.value),
              ),
            ],
          ),
        );
      },
    );
  }
}
