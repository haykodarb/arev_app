class BaseDataMap {
  final int dayNumber;
  final int timeOfDay;
  final int isResistanceOn;
  BaseDataMap({
    required this.dayNumber,
    required this.timeOfDay,
    required this.isResistanceOn,
  });

  static List<BaseDataMap> parseListFromString(String dataText) {
    List<BaseDataMap> array = [];

    final List<String> firstSplit = dataText.split(';');

    firstSplit.removeLast();

    for (String element in firstSplit) {
      final List<String> secondSplit = element.split(',');

      array.add(
        BaseDataMap(
          dayNumber: int.parse(secondSplit[0]),
          timeOfDay: int.parse(secondSplit[1]),
          isResistanceOn: int.parse(secondSplit[2]),
        ),
      );
    }

    return array;
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

  static void parseData({
    required String dataText,
    required void Function(MonthDataMap dataMap) addToArray,
    required int power,
  }) {
    List<BaseDataMap> array = BaseDataMap.parseListFromString(dataText);

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
        final MonthDataMap valueToAdd = MonthDataMap(
          dayNumber: day,
          timeOn: totalTime,
          powerConsumed: totalTime * power / 1000,
        );

        addToArray(valueToAdd);
      }
    }
  }
}
