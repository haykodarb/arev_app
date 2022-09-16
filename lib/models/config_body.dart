import 'dart:convert';

enum ParameterType {
  initialTime,
  finalTime,
  initialTemp,
  finalTemp,
  systState,
}

class ConfigBody {
  int initialTime = 1;
  int finalTime = 23;
  int initialTemp = 40;
  int finalTemp = 45;
  bool systState = false;

  ConfigBody();

  ConfigBody.fromJson(String jsonString) {
    final Map<String, dynamic> jsonObject =
        jsonDecode(jsonString) as Map<String, dynamic>;

    initialTime = jsonObject['initTime'] as int;
    finalTime = jsonObject['finalTime'] as int;
    initialTemp = jsonObject['initTemp'] as int;
    finalTemp = jsonObject['finalTemp'] as int;
    systState = jsonObject['systState'] as bool;
  }

  String toJson() {
    final Map<String, dynamic> json = <String, dynamic>{
      'initTime': initialTime,
      'finalTime': finalTime,
      'initTemp': initialTemp,
      'finalTemp': finalTemp,
      'systState': systState,
    };
    return jsonEncode(json);
  }

  String getButtonTitle({required ParameterType parameter}) {
    switch (parameter) {
      case ParameterType.initialTime:
        return 'Hora Inicial';
      case ParameterType.finalTime:
        return 'Hora Final';
      case ParameterType.initialTemp:
        return 'Temp. Inicial';
      case ParameterType.finalTemp:
        return 'Temp. Final';
      default:
        return 'Error';
    }
  }

  int getValueForParameter({required ParameterType parameter}) {
    switch (parameter) {
      case ParameterType.initialTime:
        return initialTime;
      case ParameterType.finalTime:
        return finalTime;
      case ParameterType.initialTemp:
        return initialTemp;
      case ParameterType.finalTemp:
        return finalTemp;
      default:
        return 0;
    }
  }

  String getButtonText({required ParameterType parameter}) {
    int? value = getValueForParameter(parameter: parameter);

    switch (parameter) {
      case ParameterType.initialTime:
      case ParameterType.finalTime:
        return '${value.toString().padLeft(2, '0')}:00';
      case ParameterType.initialTemp:
      case ParameterType.finalTemp:
        return '$value.00°C';
      default:
        return 'Error';
    }
  }
}
