class BaseDataMap {
  final int dayNumber;
  final int timeOfDay;
  final int isResistanceOn;
  BaseDataMap({
    required this.dayNumber,
    required this.timeOfDay,
    required this.isResistanceOn,
  });
}

class BaseDataArray {
  List<BaseDataMap> array = [];

  BaseDataArray.fromString(String dataText) {
    List<String> firstSplit = dataText.split(';');
    firstSplit.removeLast();

    for (String element in firstSplit) {
      List<String> secondSplit = element.split(',');
      array.add(BaseDataMap(
        dayNumber: int.parse(secondSplit[0]),
        timeOfDay: int.parse(secondSplit[1]),
        isResistanceOn: int.parse(secondSplit[2]),
      ));
    }
  }
}

class MonthDataMap {
  final int dayNumber;
  final double timeOn;
  final double powerConsumed;
  MonthDataMap({
    required this.dayNumber,
    required this.timeOn,
    required this.powerConsumed,
  });
}

class MonthDataArray {
  List<MonthDataMap> monthArray = [];

  MonthDataArray.fromString(String dataText, int power) {
    List<BaseDataMap> array = BaseDataArray.fromString(dataText).array;

    for (int day = 1; day <= 31; day++) {
      int addedTime = 0;

      for (int i = 1; i < array.length; i++) {
        if (array[i].isResistanceOn == 1 &&
            array[i].dayNumber == day &&
            array[i - 1].dayNumber == day) {
          addedTime = addedTime + array[i].timeOfDay - array[i - 1].timeOfDay;
        }
      }

      final double totalTime = addedTime / 3600;

      if (addedTime > 0) {
        monthArray.add(
          MonthDataMap(
            dayNumber: day,
            timeOn: totalTime,
            powerConsumed: totalTime * power / 1000,
          ),
        );
      }
    }
  }
}
