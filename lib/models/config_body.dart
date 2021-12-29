enum ParameterType {
  initialTime,
  finalTime,
  initialTemp,
  finalTemp,
  systState,
}

class ConfigBody {
  late int? initialTime;
  late int? finalTime;
  late int? initialTemp;
  late int? finalTemp;
  late int? systState;

  ConfigBody({
    this.initialTime,
    this.finalTime,
    this.initialTemp,
    this.finalTemp,
    this.systState,
  });

  ConfigBody.fromJson(Map<String, dynamic> json) {
    initialTime = json['initTime'] as int;
    finalTime = json['finalTime'] as int;
    initialTemp = json['initTemp'] as int;
    finalTemp = json['finalTemp'] as int;
    systState = json['systState'] as int;
  }

  Map<String, int?> toJson() {
    final Map<String, int?> json = {
      'initTime': initialTime,
      'finalTime': finalTime,
      'initTemp': initialTemp,
      'finalTemp': finalTemp,
      'systState': systState,
    };
    return json;
  }
}
