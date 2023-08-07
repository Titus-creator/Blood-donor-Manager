// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class RequestModel {
  String? id;
  String? requesterId;
  Map<String, dynamic>? requester;
  String? patientName;
  String? patientAge;
  String? patientGender;
  String? hospitalName;
  String? hospitalAddress;
  String? hospitalPhone;
  Map<String, dynamic>? hospitalLocation;
  List<dynamic>? bloodGroup;
  double? bloodNeeded;
  double? bloodDonated;
  List<dynamic>? donors;
  String? patientCondition;
  int? createdAt;
  String? patientImage;
  bool? isCompleted;
  RequestModel({
    this.id,
    this.requesterId,
    this.requester,
    this.patientName,
    this.patientAge,
    this.patientGender,
    this.hospitalName,
    this.hospitalAddress,
    this.hospitalPhone,
    this.hospitalLocation,
    this.bloodGroup = const [],
    this.bloodNeeded,
    this.bloodDonated,
    this.donors = const [],
    this.patientCondition,
    this.createdAt,
    this.patientImage,
    this.isCompleted = false,
  });

  RequestModel copyWith({
    String? id,
    String? requesterId,
    Map<String, dynamic>? requester,
    String? patientName,
    String? patientAge,
    String? patientGender,
    String? hospitalName,
    String? hospitalAddress,
    String? hospitalPhone,
    Map<String, dynamic>? hospitalLocation,
    List<dynamic>? bloodGroup,
    double? bloodNeeded,
    double? bloodDonated,
    List<dynamic>? donors,
    String? patientCondition,
    int? createdAt,
    String? patientImage,
    bool? isCompleted,
  }) {
    return RequestModel(
      id: id ?? this.id,
      requesterId: requesterId ?? this.requesterId,
      requester: requester ?? this.requester,
      patientName: patientName ?? this.patientName,
      patientAge: patientAge ?? this.patientAge,
      patientGender: patientGender ?? this.patientGender,
      hospitalName: hospitalName ?? this.hospitalName,
      hospitalAddress: hospitalAddress ?? this.hospitalAddress,
      hospitalPhone: hospitalPhone ?? this.hospitalPhone,
      hospitalLocation: hospitalLocation ?? this.hospitalLocation,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      bloodNeeded: bloodNeeded ?? this.bloodNeeded,
      bloodDonated: bloodDonated ?? this.bloodDonated,
      donors: donors ?? this.donors,
      patientCondition: patientCondition ?? this.patientCondition,
      createdAt: createdAt ?? this.createdAt,
      patientImage: patientImage ?? this.patientImage,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'requesterId': requesterId,
      'requester': requester,
      'patientName': patientName,
      'patientAge': patientAge,
      'patientGender': patientGender,
      'hospitalName': hospitalName,
      'hospitalAddress': hospitalAddress,
      'hospitalPhone': hospitalPhone,
      'hospitalLocation': hospitalLocation,
      'bloodGroup': bloodGroup,
      'bloodNeeded': bloodNeeded,
      'bloodDonated': bloodDonated,
      'donors': donors,
      'patientCondition': patientCondition,
      'createdAt': createdAt,
      'patientImage': patientImage,
      'isCompleted': isCompleted,
    };
  }

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      id: map['id'] != null ? map['id'] as String : null,
      requesterId:
          map['requesterId'] != null ? map['requesterId'] as String : null,
      requester: map['requester'] != null
          ? Map<String, dynamic>.from(
              (map['requester'] as Map<String, dynamic>))
          : null,
      patientName:
          map['patientName'] != null ? map['patientName'] as String : null,
      patientAge:
          map['patientAge'] != null ? map['patientAge'] as String : null,
      patientGender:
          map['patientGender'] != null ? map['patientGender'] as String : null,
      hospitalName:
          map['hospitalName'] != null ? map['hospitalName'] as String : null,
      hospitalAddress: map['hospitalAddress'] != null
          ? map['hospitalAddress'] as String
          : null,
      hospitalPhone:
          map['hospitalPhone'] != null ? map['hospitalPhone'] as String : null,
      hospitalLocation: map['hospitalLocation'] != null
          ? Map<String, dynamic>.from(
              (map['hospitalLocation'] as Map<String, dynamic>))
          : null,
      bloodGroup: map['bloodGroup'] != null
          ? List<dynamic>.from((map['bloodGroup'] as List<dynamic>))
          : null,
      bloodNeeded:
          map['bloodNeeded'] != null ? map['bloodNeeded'] as double : null,
      bloodDonated:
          map['bloodDonated'] != null ? map['bloodDonated'] as double : null,
      donors: map['donors'] != null
          ? List<dynamic>.from((map['donors'] as List<dynamic>))
          : null,
      patientCondition: map['patientCondition'] != null
          ? map['patientCondition'] as String
          : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as int : null,
      patientImage:
          map['patientImage'] != null ? map['patientImage'] as String : null,
      isCompleted:
          map['isCompleted'] != null ? map['isCompleted'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RequestModel.fromJson(String source) =>
      RequestModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RequestModel(id: $id, requesterId: $requesterId, requester: $requester, patientName: $patientName, patientAge: $patientAge, patientGender: $patientGender, hospitalName: $hospitalName, hospitalAddress: $hospitalAddress, hospitalPhone: $hospitalPhone, hospitalLocation: $hospitalLocation, bloodGroup: $bloodGroup, bloodNeeded: $bloodNeeded, bloodDonated: $bloodDonated, donors: $donors, patientCondition: $patientCondition, createdAt: $createdAt, patientImage: $patientImage, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(covariant RequestModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.requesterId == requesterId &&
        mapEquals(other.requester, requester) &&
        other.patientName == patientName &&
        other.patientAge == patientAge &&
        other.patientGender == patientGender &&
        other.hospitalName == hospitalName &&
        other.hospitalAddress == hospitalAddress &&
        other.hospitalPhone == hospitalPhone &&
        mapEquals(other.hospitalLocation, hospitalLocation) &&
        listEquals(other.bloodGroup, bloodGroup) &&
        other.bloodNeeded == bloodNeeded &&
        other.bloodDonated == bloodDonated &&
        listEquals(other.donors, donors) &&
        other.patientCondition == patientCondition &&
        other.createdAt == createdAt &&
        other.patientImage == patientImage &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        requesterId.hashCode ^
        requester.hashCode ^
        patientName.hashCode ^
        patientAge.hashCode ^
        patientGender.hashCode ^
        hospitalName.hashCode ^
        hospitalAddress.hashCode ^
        hospitalPhone.hashCode ^
        hospitalLocation.hashCode ^
        bloodGroup.hashCode ^
        bloodNeeded.hashCode ^
        bloodDonated.hashCode ^
        donors.hashCode ^
        patientCondition.hashCode ^
        createdAt.hashCode ^
        patientImage.hashCode ^
        isCompleted.hashCode;
  }

  RequestModel clear() {
    return RequestModel(
      id: null,
      requesterId: null,
      requester: null,
      patientName: null,
      patientAge: null,
      patientGender: null,
      hospitalName: null,
      hospitalAddress: null,
      hospitalPhone: null,
      hospitalLocation: null,
      bloodGroup: const [],
      bloodNeeded: null,
      bloodDonated: null,
      donors: const [],
      patientCondition: null,
      createdAt: null,
      patientImage: null,
      isCompleted: false,
    );
  }

  Map<Object, Object?> donorUpdateMap() {
    return <Object, Object?>{
      'donors': donors,
    };
  }
}
