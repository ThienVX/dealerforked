import 'package:dealer_app/repositories/models/get_promotion_model.dart';
import 'dart:convert';

GetPromotionResponseModel getPromotionResponseModelFromJson(String str) =>
    GetPromotionResponseModel.fromJson(json.decode(str));

class GetPromotionResponseModel {
  GetPromotionResponseModel({
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
  int total;
  List<GetPromotionModel> resData;

  factory GetPromotionResponseModel.fromJson(Map<String, dynamic> json) =>
      GetPromotionResponseModel(
        isSuccess: json["isSuccess"] == null ? null : json["isSuccess"],
        statusCode: json["statusCode"] == null ? null : json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"] == null ? null : json["total"],
        resData: List<GetPromotionModel>.from(
            json["resData"].map((x) => GetPromotionModel.fromJson(x))),
      );
}
