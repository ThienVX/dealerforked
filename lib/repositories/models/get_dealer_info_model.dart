// To parse this JSON data, do
//
//     final getDealerInfoModel = getDealerInfoModelFromJson(jsonString);

import 'dart:convert';

GetDealerInfoModel getDealerInfoModelFromJson(String str) =>
    GetDealerInfoModel.fromJson(json.decode(str));

class GetDealerInfoModel {
  GetDealerInfoModel({
    required this.id,
    required this.dealerName,
    required this.dealerImageUrl,
    required this.dealerLatitude,
    required this.dealerLongtitude,
    required this.dealerAddress,
    required this.dealerPhone,
    required this.openTime,
    required this.closeTime,
  });

  String id;
  String dealerName;
  String dealerImageUrl;
  double dealerLatitude;
  double dealerLongtitude;
  String dealerAddress;
  String dealerPhone;
  String openTime;
  String closeTime;

  factory GetDealerInfoModel.fromJson(Map<String, dynamic> json) =>
      GetDealerInfoModel(
        id: json["id"] == null ? null : json["id"],
        dealerName: json["dealerName"] == null ? null : json["dealerName"],
        dealerImageUrl:
            json["dealerImageUrl"] == null ? null : json["dealerImageUrl"],
        dealerLatitude: json["dealerLatitude"] == null
            ? null
            : json["dealerLatitude"].toDouble(),
        dealerLongtitude: json["dealerLongtitude"] == null
            ? null
            : json["dealerLongtitude"].toDouble(),
        dealerAddress:
            json["dealerAddress"] == null ? null : json["dealerAddress"],
        dealerPhone: json["dealerPhone"] == null ? null : json["dealerPhone"],
        openTime: json["openTime"] == null ? null : json["openTime"],
        closeTime: json["closeTime"] == null ? null : json["closeTime"],
      );
}
