import 'dart:convert';

import 'package:dealer_app/repositories/models/response_models/base_response_model.dart';

GetStatisticResponseModel getStatisticResponseModelFromJson(String str) =>
    GetStatisticResponseModel.fromJson(json.decode(str));

class GetStatisticResponseModel extends BaseResponseModel {
  GetStatisticResponseModel({
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

  factory GetStatisticResponseModel.fromJson(Map<String, dynamic> json) =>
      GetStatisticResponseModel(
        isSuccess: json["isSuccess"],
        statusCode: json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData:
            json["resData"] == null ? null : ResData.fromJson(json["resData"]),
      );
}

class ResData {
  ResData({
    required this.totalCollecting,
    required this.totalFee,
    required this.bonusAmount,
    required this.numOfCompletedTrans,
  });

  final int totalCollecting;
  final int totalFee;
  final int bonusAmount;
  final int numOfCompletedTrans;

  factory ResData.fromJson(Map<String, dynamic> json) => ResData(
        totalCollecting: json["totalCollecting"],
        totalFee: json["totalFee"],
        bonusAmount: json["bonusAmount"],
        numOfCompletedTrans: json["numOfCompletedTrans"],
      );
}
