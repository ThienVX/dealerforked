// To parse this JSON data, do
//
//     final dealerResponseModel = dealerResponseModelFromJson(jsonString);

import 'package:dealer_app/repositories/models/dealer_info_model.dart';
import 'dart:convert';

DealerResponseModel dealerResponseModelFromJson(String str) =>
    DealerResponseModel.fromJson(json.decode(str));

String dealerResponseModelToJson(DealerResponseModel data) =>
    json.encode(data.toJson());

class DealerResponseModel {
  DealerResponseModel({
    required this.isSuccess,
    required this.statusCode,
    this.msgCode,
    this.msgDetail,
    this.total,
    required this.dealerInfoModel,
  });

  bool isSuccess;
  int statusCode;
  dynamic msgCode;
  dynamic msgDetail;
  dynamic total;
  DealerInfoModel dealerInfoModel;

  factory DealerResponseModel.fromJson(Map<String, dynamic> json) =>
      DealerResponseModel(
        isSuccess: json["isSuccess"] == null ? null : json["isSuccess"],
        statusCode: json["statusCode"] == null ? null : json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        dealerInfoModel: DealerInfoModel.fromJson(json["resData"]),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "statusCode": statusCode,
        "msgCode": msgCode,
        "msgDetail": msgDetail,
        "total": total,
        "resData": dealerInfoModel.toJson(),
      };
}
