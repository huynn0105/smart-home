import 'package:smart_home_app/core/model/control_model.dart';
import 'package:smart_home_app/core/model/data_model.dart';

class NodeModel {
  final ControlModel control;
  final DataModel data;
  final DataModel threshold;

  NodeModel({
    required this.control,
    required this.data,
    required this.threshold,
  });

  factory NodeModel.create() {
    return NodeModel(
      control: ControlModel.create(),
      data: DataModel.create(),
      threshold: DataModel.create(),
    );
  }

  NodeModel.fromJson(Map<dynamic, dynamic> json)
      : control = ControlModel.fromJson(json['control']),
        data = DataModel.fromJson(json['data']),
        threshold = DataModel.fromJson(json['threshold']);

  Map<String, Object?> toJson() => <String, Object?>{
        'control': control.toJson(),
        'data': data.toJson(),
        'threshold': threshold.toJson(),
      };
}
