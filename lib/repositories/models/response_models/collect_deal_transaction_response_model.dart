// To parse this JSON data, do
//
//     final collectDealTransactionResponseModel = collectDealTransactionResponseModelFromJson(jsonString);

import 'dart:convert';

import '../collect_deal_transaction_model.dart';

CollectDealTransactionResponseModel collectDealTransactionResponseModelFromJson(
        String str) =>
    CollectDealTransactionResponseModel.fromJson(json.decode(str));

String collectDealTransactionResponseModelToJson(
        CollectDealTransactionResponseModel data) =>
    json.encode(data.toJson());

class CollectDealTransactionResponseModel {
  CollectDealTransactionResponseModel({
    required this.isSuccess,
    required this.statusCode,
    this.msgCode,
    this.msgDetail,
    required this.total,
    required this.resData,
  });

  bool isSuccess;
  int statusCode;
  dynamic msgCode;
  dynamic msgDetail;
  int total;
  List<CollectDealTransactionModel> resData;

  factory CollectDealTransactionResponseModel.fromJson(
          Map<String, dynamic> json) =>
      CollectDealTransactionResponseModel(
        isSuccess: json["isSuccess"],
        statusCode: json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData: List<CollectDealTransactionModel>.from(json["resData"]
            .map((x) => CollectDealTransactionModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "statusCode": statusCode,
        "msgCode": msgCode,
        "msgDetail": msgDetail,
        "total": total,
        "resData": List<dynamic>.from(resData.map((x) => x.toJson())),
      };
}
