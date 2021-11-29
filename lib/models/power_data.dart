import 'package:app_get/models/day_data.dart';
import 'package:app_get/models/month_data.dart';

class PowerDataClass {
  late double powerConsumed;
  late double timeOn;

  PowerDataClass.fromDailyDataArray(DayDataArray arrayClass, int power) {
    List<DayDataMap> array = arrayClass.dayDataArray;

    double accTime = 0;

    for (int i = 1; i < array.length; i++) {
      if (array[i].isResistanceOn == 1) {
        accTime += array[i].timeOfDay - array[i - 1].timeOfDay;
      }
    }
    timeOn = accTime;
    powerConsumed = timeOn * power / 1000;
  }

  PowerDataClass.fromMonthDataArray(MonthDataArray arrayClass, int power) {
    List<MonthDataMap> array = arrayClass.monthArray;

    double accTime = 0;

    for (int i = 0; i < array.length; i++) {
      accTime += array[i].timeOn;
    }

    timeOn = accTime;
    powerConsumed = timeOn * power / 1000;
  }
}
