// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DonationModel {
  String? id;
  String? donorId;
  String? requestId;
  int? date;
  int? time;
  int? createdAt;
  String? status;
  String? donorName;
  String? patientName;
  String? patientImage;
  String? donorImage;
  String? bloodGroup;
  double? bloodQuantity;
  DonationModel({
    this.id,
    this.donorId,
    this.requestId,
    this.date,
    this.time,
    this.createdAt,
    this.status,
    this.donorName,
    this.patientName,
    this.patientImage,
    this.donorImage,
    this.bloodGroup,
    this.bloodQuantity,
  });

  DonationModel copyWith({
    String? id,
    String? donorId,
    String? requestId,
    int? date,
    int? time,
    int? createdAt,
    String? status,
    String? donorName,
    String? patientName,
    String? patientImage,
    String? donorImage,
    String? bloodGroup,
    double? bloodQuantity,
  }) {
    return DonationModel(
      id: id ?? this.id,
      donorId: donorId ?? this.donorId,
      requestId: requestId ?? this.requestId,
      date: date ?? this.date,
      time: time ?? this.time,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      donorName: donorName ?? this.donorName,
      patientName: patientName ?? this.patientName,
      patientImage: patientImage ?? this.patientImage,
      donorImage: donorImage ?? this.donorImage,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      bloodQuantity: bloodQuantity ?? this.bloodQuantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'donorId': donorId,
      'requestId': requestId,
      'date': date,
      'time': time,
      'createdAt': createdAt,
      'status': status,
      'donorName': donorName,
      'patientName': patientName,
      'patientImage': patientImage,
      'donorImage': donorImage,
      'bloodGroup': bloodGroup,
      'bloodQuantity': bloodQuantity,
    };
  }

  factory DonationModel.fromMap(Map<String, dynamic> map) {
    return DonationModel(
      id: map['id'] != null ? map['id'] as String : null,
      donorId: map['donorId'] != null ? map['donorId'] as String : null,
      requestId: map['requestId'] != null ? map['requestId'] as String : null,
      date: map['date'] != null ? map['date'] as int : null,
      time: map['time'] != null ? map['time'] as int : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as int : null,
      status: map['status'] != null ? map['status'] as String : null,
      donorName: map['donorName'] != null ? map['donorName'] as String : null,
      patientName:
          map['patientName'] != null ? map['patientName'] as String : null,
      patientImage:
          map['patientImage'] != null ? map['patientImage'] as String : null,
      donorImage:
          map['donorImage'] != null ? map['donorImage'] as String : null,
      bloodGroup:
          map['bloodGroup'] != null ? map['bloodGroup'] as String : null,
      bloodQuantity:
          map['bloodQuantity'] != null ? map['bloodQuantity'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DonationModel.fromJson(String source) =>
      DonationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DonationModel(id: $id, donorId: $donorId, requestId: $requestId, date: $date, time: $time, createdAt: $createdAt, status: $status, donorName: $donorName, patientName: $patientName, patientImage: $patientImage, donorImage: $donorImage, bloodGroup: $bloodGroup, bloodQuantity: $bloodQuantity)';
  }

  @override
  bool operator ==(covariant DonationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.donorId == donorId &&
        other.requestId == requestId &&
        other.date == date &&
        other.time == time &&
        other.createdAt == createdAt &&
        other.status == status &&
        other.donorName == donorName &&
        other.patientName == patientName &&
        other.patientImage == patientImage &&
        other.donorImage == donorImage &&
        other.bloodGroup == bloodGroup &&
        other.bloodQuantity == bloodQuantity;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        donorId.hashCode ^
        requestId.hashCode ^
        date.hashCode ^
        time.hashCode ^
        createdAt.hashCode ^
        status.hashCode ^
        donorName.hashCode ^
        patientName.hashCode ^
        patientImage.hashCode ^
        donorImage.hashCode ^
        bloodGroup.hashCode ^
        bloodQuantity.hashCode;
  }

  DonationModel clear() {
    //set all values to null
    return DonationModel(
      id: null,
      donorId: null,
      requestId: null,
      date: null,
      time: null,
      createdAt: null,
      status: null,
      donorName: null,
      patientName: null,
      patientImage: null,
      donorImage: null,
      bloodGroup: null,
      bloodQuantity: null,
    );
  }
}
