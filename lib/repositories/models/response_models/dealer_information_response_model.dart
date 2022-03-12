import 'dart:convert';

import 'package:dealer_app/repositories/models/response_models/base_response_model.dart';

DealerInformationResponseModel dealerInformationResponseModelFromJson(
        String str) =>
    DealerInformationResponseModel.fromJson(json.decode(str));

class DealerInformationResponseModel extends BaseResponseModel {
  DealerInformationResponseModel({
    required bool isSuccess,
    required int statusCode,
    this.msgCode,
    this.msgDetail,
    this.total,
    this.resData,
  }) : super(
          isSuccess: isSuccess,
          statusCode: statusCode,
        );

  final dynamic msgCode;
  final dynamic msgDetail;
  final dynamic total;
  final ResData? resData;

  factory DealerInformationResponseModel.fromJson(Map<String, dynamic> json) =>
      DealerInformationResponseModel(
        isSuccess: json["isSuccess"],
        statusCode: json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData: ResData.fromJson(json["resData"]),
      );
}

class ResData {
  ResData({
    required this.id,
    required this.dealerName,
    this.dealerImageUrl,
    required this.dealerLatitude,
    required this.dealerLongtitude,
    required this.dealerAddress,
    required this.dealerPhone,
    required this.openTime,
    required this.closeTime,
    required this.isActive,
  });

  final String id;
  final String dealerName;
  final String? dealerImageUrl;
  final double dealerLatitude;
  final double dealerLongtitude;
  final String dealerAddress;
  final String dealerPhone;
  final String openTime;
  final String closeTime;
  final bool isActive;

  factory ResData.fromJson(Map<String, dynamic> json) => ResData(
        id: json["id"],
        dealerName: json["dealerName"],
        dealerImageUrl: json["dealerImageUrl"],
        dealerLatitude: json["dealerLatitude"].toDouble(),
        dealerLongtitude: json["dealerLongtitude"].toDouble(),
        dealerAddress: json["dealerAddress"],
        dealerPhone: json["dealerPhone"],
        openTime: json["openTime"],
        closeTime: json["closeTime"],
        isActive: json["isActive"],
      );
}
