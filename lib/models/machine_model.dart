import 'package:flutter/foundation.dart';

@immutable
class MachineModel {
  const MachineModel({
    required this.id,
    required this.title,
    required this.status,
    required this.isEmergency,
  });

  factory MachineModel.fromJson(Map<String, dynamic> json) {
    return MachineModel(
      id: json['id'] as String,
      title: json['title'] as String,
      status: json['status'] as String,
      isEmergency: json['isEmergency'] as bool,
    );
  }

  final String id;
  final String title;
  final String status;
  final bool isEmergency;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'status': status,
      'isEmergency': isEmergency,
    };
  }

  MachineModel copyWith({
    String? title,
    String? status,
    bool? isEmergency,
  }) {
    return MachineModel(
      id: id,
      title: title ?? this.title,
      status: status ?? this.status,
      isEmergency: isEmergency ?? this.isEmergency,
    );
  }
}
