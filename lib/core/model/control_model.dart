class ControlModel {
  final bool autoControl;
  final bool fan;
  final bool lamp;
  final bool motor;
  ControlModel({
    required this.autoControl,
    required this.fan,
    required this.lamp,
    required this.motor,
  });

  ControlModel.fromJson(Map<String, Object?> json)
      : this(
          autoControl: json['autoControl']! as bool,
          fan: json['fan']! as bool,
          lamp: json['lamp']! as bool,
          motor: json['motor']! as bool,
        );

  Map<String, Object?> toJson() {
    return {
      'autoController': autoControl,
      'fan': fan,
      'lamp': lamp,
      'motor': motor,
    };
  }
}
