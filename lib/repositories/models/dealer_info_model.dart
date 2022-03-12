// To parse this JSON data, do
//
//     final dealerInfoModel = dealerInfoModelFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

DealerInfoModel dealerInfoModelFromJson(String str) =>
    DealerInfoModel.fromJson(json.decode(str));

String dealerInfoModelToJson(DealerInfoModel data) =>
    json.encode(data.toJson());

class DealerInfoModel extends Equatable {
  DealerInfoModel({
    required this.id,
    required this.name,
    required this.userName,
    required this.email,
    this.gender,
    required this.phone,
    required this.address,
    required this.birthDate,
    required this.image,
    required this.roleKey,
    required this.roleName,
    required this.idCard,
    this.totalPoint,
    required this.createdTime,
    this.status,
  });

  final String id;
  final String name;
  final String userName;
  final String email;
  final int? gender;
  final String phone;
  final String address;
  final String birthDate;
  final String image;
  final int roleKey;
  final String roleName;
  final String idCard;
  final int? totalPoint;
  final String createdTime;
  final int? status;

  factory DealerInfoModel.fromJson(Map<String, dynamic> json) =>
      DealerInfoModel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        userName: json["userName"] == null ? null : json["userName"],
        email: json["email"] == null ? null : json["email"],
        gender: json["gender"] == null ? null : json["gender"],
        phone: json["phone"] == null ? null : json["phone"],
        address: json["address"] == null ? null : json["address"],
        birthDate: json["birthDate"] == null ? null : json["birthDate"],
        image: json["image"],
        roleKey: json["roleKey"] == null ? null : json["roleKey"],
        roleName: json["roleName"] == null ? null : json["roleName"],
        idCard: json["idCard"] == null ? null : json["idCard"],
        totalPoint: json["totalPoint"] == null ? null : json["totalPoint"],
        createdTime: json["createdTime"] == null ? null : json["createdTime"],
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "userName": userName,
        "email": email,
        "gender": gender,
        "phone": phone,
        "address": address,
        "birthDate": birthDate,
        "image": image,
        "roleKey": roleKey,
        "roleName": roleName,
        "idCard": idCard,
        "totalPoint": totalPoint,
        "createdTime": createdTime,
        "status": status == null ? null : status,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        userName,
        email,
        gender,
        phone,
        address,
        birthDate,
        image,
        roleKey,
        roleName,
        idCard,
        totalPoint,
        createdTime,
        status,
      ];
}
