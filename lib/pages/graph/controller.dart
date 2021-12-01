import 'package:app_get/data/stats.dart';
import 'package:app_get/models/day_data.dart';
import 'package:app_get/models/month_data.dart';
import 'package:app_get/models/power_data.dart';
import 'package:app_get/models/zeroconf.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

enum GraphType {
  day,
  month,
}

Future<DateTime?> _getDay() async {
  final DateTime currentDate = DateTime.now();

  final BuildContext context = Get.context!;

  final DateTime? pickedDay = await showDatePicker(
    context: context,
    initialDate: currentDate,
    firstDate: DateTime(2020),
    lastDate: DateTime(2050),
    locale: const Locale('es', 'ES'),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                surface: Theme.of(context).colorScheme.primary,
              ),
        ),
        child: child!,
      );
    },
  );

  return pickedDay;
}

Future<DateTime?> _getMonth() async {
  final DateTime currentDate = DateTime.now();

  final BuildContext context = Get.context!;

  final DateTime? pickedDate = await showMonthPicker(
    context: context,
    initialDate: currentDate,
    locale: const Locale('es', 'ES'),
  );

  return pickedDate;
}

class GraphPageController extends GetxController {
  @override
  void onInit() {
    final DateTime currentDate = DateTime.now();
    dayButtonCallback(alreadySelectedDate: currentDate);
    super.onInit();
  }

  final ZeroconfService currentDevice =
      Get.arguments['currentDevice'] as ZeroconfService;

  Rx<GraphType> selectedType = GraphType.day.obs;

  RxList<DayDataMap> dayGraphData = <DayDataMap>[].obs;

  RxList<MonthDataMap> monthGraphData = <MonthDataMap>[].obs;

  Rx<PowerData> powerData = PowerData().obs;

  Rx<bool> isGraphLoaded = false.obs;

  void _addToDayGraphData(DayDataMap dayDataMap) {
    dayGraphData.add(dayDataMap);
  }

  void _emptyDayGraphData() {
    dayGraphData.value = [];
  }

  void _addToMonthGraphData(MonthDataMap monthDataMap) {
    monthGraphData.add(monthDataMap);
  }

  void _emptyMonthGraphData() {
    monthGraphData.value = [];
  }

  Future<void> dayButtonCallback({DateTime? alreadySelectedDate}) async {
    final DateTime? pickedDay = alreadySelectedDate ?? await _getDay();

    if (pickedDay == null) return;

    isGraphLoaded.value = false;

    final String? dataAsString = await GraphBackend.getDayData(
      url: currentDevice.ipAddress,
      selectedDate: pickedDay,
    );

    if (dataAsString == null) return;

    _emptyDayGraphData();

    DayDataMap.parseDayData(
      dataText: dataAsString,
      addToArray: _addToDayGraphData,
    );

    powerData(
      PowerData.fromDailyDataArray(
        array: dayGraphData,
        power: currentDevice.power,
      ),
    );

    selectedType.value = GraphType.day;

    isGraphLoaded.value = true;

    return;
  }

  Future<void> monthButtonCallback() async {
    final DateTime? pickedMonth = await _getMonth();

    if (pickedMonth == null) return;

    isGraphLoaded.value = false;

    final String? dataAsString = await GraphBackend.getMonthData(
      url: currentDevice.ipAddress,
      selectedDate: pickedMonth,
    );

    if (dataAsString == null) return;

    _emptyMonthGraphData();

    MonthDataMap.parseData(
      dataText: dataAsString,
      addToArray: _addToMonthGraphData,
      power: currentDevice.power,
    );

    powerData(
      PowerData.fromMonthDataArray(
        monthGraphData,
        currentDevice.power,
      ),
    );

    selectedType.value = GraphType.month;

    isGraphLoaded.value = true;

    return;
  }
}
