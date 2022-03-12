// To parse this JSON data, do
//
//     final getDealerInfoResponseModel = getDealerInfoResponseModelFromJson(jsonString);

import 'dart:convert';

import '../get_dealer_info_model.dart';

GetDealerInfoResponseModel getDealerInfoResponseModelFromJson(String str) =>
    GetDealerInfoResponseModel.fromJson(json.decode(str));

class GetDealerInfoResponseModel {
  GetDealerInfoResponseModel({
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
  GetDealerInfoModel resData;

  factory GetDealerInfoResponseModel.fromJson(Map<String, dynamic> json) =>
      GetDealerInfoResponseModel(
        isSuccess: json["isSuccess"] == null ? null : json["isSuccess"],
        statusCode: json["statusCode"] == null ? null : json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData: GetDealerInfoModel.fromJson(json["resData"]),
      );
}
