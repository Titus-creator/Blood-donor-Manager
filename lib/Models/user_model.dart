// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {
  String? uid;
  String? name;
  String? email;
  String? phone;
  String? profileUrl;
  String? password;
  String? dob;
  String? gender;
// user medical info
  String? bloodGroup;
  double? height;
  double? weight;
  List<String>? medicalHistory;
  String? vaccination;
  String? genotype;

// user address info
  String? address;
  String? region;
  String? city;

  int? createdAt;
  UserModel({
    this.uid,
    this.name,
    this.email,
    this.phone,
    this.profileUrl,
    this.password,
    this.dob,
    this.gender,
    this.bloodGroup,
    this.height,
    this.weight,
    this.medicalHistory,
    this.vaccination,
    this.genotype,
    this.address,
    this.region,
    this.city,
    this.createdAt,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? profileUrl,
    String? password,
    String? dob,
    String? gender,
    String? bloodGroup,
    double? height,
    double? weight,
    List<String>? medicalHistory,
    String? vaccination,
    String? genotype,
    String? address,
    String? region,
    String? city,
    int? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileUrl: profileUrl ?? this.profileUrl,
      password: password ?? this.password,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      vaccination: vaccination ?? this.vaccination,
      genotype: genotype ?? this.genotype,
      address: address ?? this.address,
      region: region ?? this.region,
      city: city ?? this.city,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'profileUrl': profileUrl,
      'password': password,
      'dob': dob,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'height': height,
      'weight': weight,
      'medicalHistory': medicalHistory,
      'vaccination': vaccination,
      'genotype': genotype,
      'address': address,
      'region': region,
      'city': city,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      profileUrl:
          map['profileUrl'] != null ? map['profileUrl'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      dob: map['dob'] != null ? map['dob'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      bloodGroup:
          map['bloodGroup'] != null ? map['bloodGroup'] as String : null,
      height: map['height'] != null ? map['height'] as double : null,
      weight: map['weight'] != null ? map['weight'] as double : null,
      medicalHistory: map['medicalHistory'] != null
          ? List<String>.from((map['medicalHistory'] as List<String>))
          : null,
      vaccination:
          map['vaccination'] != null ? map['vaccination'] as String : null,
      genotype: map['genotype'] != null ? map['genotype'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      region: map['region'] != null ? map['region'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, phone: $phone, profileUrl: $profileUrl, password: $password, dob: $dob, gender: $gender, bloodGroup: $bloodGroup, height: $height, weight: $weight, medicalHistory: $medicalHistory, vaccination: $vaccination, genotype: $genotype, address: $address, region: $region, city: $city, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.profileUrl == profileUrl &&
        other.password == password &&
        other.dob == dob &&
        other.gender == gender &&
        other.bloodGroup == bloodGroup &&
        other.height == height &&
        other.weight == weight &&
        listEquals(other.medicalHistory, medicalHistory) &&
        other.vaccination == vaccination &&
        other.genotype == genotype &&
        other.address == address &&
        other.region == region &&
        other.city == city &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        profileUrl.hashCode ^
        password.hashCode ^
        dob.hashCode ^
        gender.hashCode ^
        bloodGroup.hashCode ^
        height.hashCode ^
        weight.hashCode ^
        medicalHistory.hashCode ^
        vaccination.hashCode ^
        genotype.hashCode ^
        address.hashCode ^
        region.hashCode ^
        city.hashCode ^
        createdAt.hashCode;
  }
}
