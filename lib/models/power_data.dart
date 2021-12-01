import 'package:app_get/models/day_data.dart';
import 'package:app_get/models/month_data.dart';

class PowerData {
  double powerConsumed = 0;
  double timeOn = 0;

  PowerData();

  PowerData.fromDailyDataArray({
    required List<DayDataMap> array,
    required int power,
  }) {
    double accTime = 0;

    for (int i = 1; i < array.length; i++) {
      if (array[i].isResistanceOn == 1) {
        accTime += array[i].timeOfDay - array[i - 1].timeOfDay;
      }
    }
    timeOn = accTime;
    powerConsumed = timeOn * power / 1000;
  }

  PowerData.fromMonthDataArray(List<MonthDataMap> array, int power) {
    double accTime = 0;

    for (int i = 0; i < array.length; i++) {
      accTime += array[i].timeOn;
    }

    timeOn = accTime;
    powerConsumed = timeOn * power / 1000;
  }
}
