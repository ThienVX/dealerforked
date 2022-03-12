import 'dart:convert';

import '../get_promotion_detail_model.dart';

GetPromotionDetailResponseModel getPromotionDetailResponseModelFromJson(
        String str) =>
    GetPromotionDetailResponseModel.fromJson(json.decode(str));

class GetPromotionDetailResponseModel {
  GetPromotionDetailResponseModel({
    required this.isSuccess,
    required this.statusCode,
    required this.msgCode,
    required this.msgDetail,
    required this.total,
    required this.resData,
  });

  bool isSuccess;
  int statusCode;
  dynamic msgCode;
  dynamic msgDetail;
  dynamic total;
  GetPromotionDetailModel resData;

  factory GetPromotionDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      GetPromotionDetailResponseModel(
        isSuccess: json["isSuccess"] == null ? null : json["isSuccess"],
        statusCode: json["statusCode"] == null ? null : json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData: GetPromotionDetailModel.fromJson(json["resData"]),
      );
}
