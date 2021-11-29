class DayDataMap {
  final double timeOfDay;
  final double temperature;
  int isResistanceOn;

  DayDataMap({
    required this.timeOfDay,
    required this.temperature,
    required this.isResistanceOn,
  });
}

class DayDataArray {
  List<DayDataMap> dayDataArray = [];

  DayDataArray.fromString(String dataText) {
    List<String> firstSplit = dataText.split(';');

    firstSplit.removeLast();

    for (String element in firstSplit) {
      List<String> secondSplit = element.split(',');

      DayDataMap parsedData = DayDataMap(
        isResistanceOn: int.parse(secondSplit[2]),
        temperature: double.parse(secondSplit[1]),
        timeOfDay: int.parse(secondSplit[0]) / 3600,
      );

      dayDataArray.add(parsedData);
    }
  }
}
