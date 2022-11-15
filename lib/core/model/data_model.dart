import 'package:cloud_firestore/cloud_firestore.dart';

class DataModel {
  final String humi;
  final String light;
  final String temp;
  DataModel({
    required this.humi,
    required this.light,
    required this.temp,
  });

  DataModel.fromJson(Map<String, Object?> json)
      : this(
          humi: json['humi'] as String,
          light: json['light'] as String,
          temp: json['temp'] as String,
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
