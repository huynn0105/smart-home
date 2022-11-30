class DataModel {
  final double humi;
  final double light;
  final double temp;
  DataModel({
    required this.humi,
    required this.light,
    required this.temp,
  });

  factory DataModel.create() {
    return DataModel(
      humi: 0,
      light: 0,
      temp: 0,
    );
  }

  DataModel.fromJson(Map<dynamic, dynamic> json)
      : this(
          humi: checkDouble(json['humi']),
          light: checkDouble(json['light']),
          temp: checkDouble(json['temp']),
        );
  Map<String, Object?> toJson() {
    return {
      'humi': humi,
      'light': light,
      'temp': temp,
    };
  }
}

double checkDouble(dynamic value) {
  if (value is String) {
    return double.parse(value);
  } else if (value is int) {
    return value.toDouble();
  } else {
    return value;
  }
}
