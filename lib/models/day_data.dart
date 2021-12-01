import 'package:intl/intl.dart';

class DayDataMap {
  DayDataMap({
    required this.timeOfDay,
    required this.temperature,
    required this.isResistanceOn,
  });

  late double timeOfDay;
  late double temperature;
  late int isResistanceOn;

  static void parseDayData({
    required String dataText,
    required void Function(DayDataMap dataMap) addToArray,
  }) {
    final List<String> firstSplit = dataText.split(';');

    firstSplit.removeLast();

    for (String element in firstSplit) {
      final List<String> secondSplit = element.split(',');

      final DayDataMap parsedData = DayDataMap(
        isResistanceOn: int.parse(secondSplit[2]),
        temperature: double.parse(secondSplit[1]),
        timeOfDay: int.parse(secondSplit[0]) / 3600,
      );

      addToArray(parsedData);
    }
  }

  static DateTime formatTime(double timeInDouble) {
    int hora = timeInDouble.floor();
    double minutosDouble = (timeInDouble - hora) * 60;
    int minutos = minutosDouble.floor();
    String horaString = hora.toString().padLeft(2, '0');
    String minutosString = minutos.toString().padLeft(2, '0');
    final DateFormat format = DateFormat('HH:mm');
    DateTime dateTime = format.parse('$horaString:$minutosString');
    return dateTime;
  }
}
