import 'dart:convert';

import '../collect_deal_transaction_history_detail_model.dart';

CollectDealTransactionHistoryDetailResponseModel
    collectDealTransactionDetailResponseModelFromJson(String str) =>
        CollectDealTransactionHistoryDetailResponseModel.fromJson(
            json.decode(str));

class CollectDealTransactionHistoryDetailResponseModel {
  CollectDealTransactionHistoryDetailResponseModel({
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
  CDTransactionHistoryDetailModel resData;

  factory CollectDealTransactionHistoryDetailResponseModel.fromJson(
          Map<String, dynamic> json) =>
      CollectDealTransactionHistoryDetailResponseModel(
        isSuccess: json["isSuccess"] == null ? null : json["isSuccess"],
        statusCode: json["statusCode"] == null ? null : json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData: CDTransactionHistoryDetailModel.fromJson(json["resData"]),
      );
}
