// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class HistoryModel {
  String? id;
  String? type;
  String? status;
  int? createdAt;
  double? quantity;
  List<dynamic>? bloodType;
  HistoryModel({
    this.id,
    this.type,
    this.status,
    this.createdAt,
    this.quantity,
    this.bloodType,
  });


  HistoryModel copyWith({
    String? id,
    String? type,
    String? status,
    int? createdAt,
    double? quantity,
    List<dynamic>? bloodType,
  }) {
    return HistoryModel(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      quantity: quantity ?? this.quantity,
      bloodType: bloodType ?? this.bloodType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'status': status,
      'createdAt': createdAt,
      'quantity': quantity,
      'bloodType': bloodType,
    };
  }

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      id: map['id'] != null ? map['id'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as int : null,
      quantity: map['quantity'] != null ? map['quantity'] as double : null,
      bloodType: map['bloodType'] != null ? List<dynamic>.from((map['bloodType'] as List<dynamic>)) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoryModel.fromJson(String source) => HistoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'HistoryModel(id: $id, type: $type, status: $status, createdAt: $createdAt, quantity: $quantity, bloodType: $bloodType)';
  }

  @override
  bool operator ==(covariant HistoryModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.type == type &&
      other.status == status &&
      other.createdAt == createdAt &&
      other.quantity == quantity &&
      listEquals(other.bloodType, bloodType);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      type.hashCode ^
      status.hashCode ^
      createdAt.hashCode ^
      quantity.hashCode ^
      bloodType.hashCode;
  }
}
