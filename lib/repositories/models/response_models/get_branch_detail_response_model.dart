// To parse this JSON data, do
//
//     final getBranchDetailResponseModel = getBranchDetailResponseModelFromJson(jsonString);

import 'dart:convert';

GetBranchDetailResponseModel getBranchDetailResponseModelFromJson(String str) =>
    GetBranchDetailResponseModel.fromJson(json.decode(str));

class GetBranchDetailResponseModel {
  GetBranchDetailResponseModel({
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
  GetBranchDetailModel resData;

  factory GetBranchDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      GetBranchDetailResponseModel(
        isSuccess: json["isSuccess"] == null ? null : json["isSuccess"],
        statusCode: json["statusCode"] == null ? null : json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData: GetBranchDetailModel.fromJson(json["resData"]),
      );
}

class GetBranchDetailModel {
  GetBranchDetailModel({
    required this.id,
    required this.dealerBranchImageUrl,
    required this.dealerBranchName,
    required this.dealerBranchPhone,
    required this.dealerBranchAddress,
    required this.dealerBranchOpenTime,
    required this.dealerBranchCloseTime,
    required this.dealerAccountBranch,
  });

  String id;
  String dealerBranchImageUrl;
  String dealerBranchName;
  String dealerBranchPhone;
  String dealerBranchAddress;
  String dealerBranchOpenTime;
  String dealerBranchCloseTime;
  DealerAccountBranch dealerAccountBranch;

  factory GetBranchDetailModel.fromJson(Map<String, dynamic> json) =>
      GetBranchDetailModel(
        id: json["id"] == null ? null : json["id"],
        dealerBranchImageUrl: json["dealerBranchImageUrl"] == null
            ? null
            : json["dealerBranchImageUrl"],
        dealerBranchName:
            json["dealerBranchName"] == null ? null : json["dealerBranchName"],
        dealerBranchPhone: json["dealerBranchPhone"] == null
            ? null
            : json["dealerBranchPhone"],
        dealerBranchAddress: json["dealerBranchAddress"] == null
            ? null
            : json["dealerBranchAddress"],
        dealerBranchOpenTime: json["dealerBranchOpenTime"] == null
            ? null
            : json["dealerBranchOpenTime"],
        dealerBranchCloseTime: json["dealerBranchCloseTime"] == null
            ? null
            : json["dealerBranchCloseTime"],
        dealerAccountBranch:
            DealerAccountBranch.fromJson(json["dealerAccountBranch"]),
      );
}

class DealerAccountBranch {
  DealerAccountBranch({
    required this.name,
    required this.phone,
  });

  String name;
  String phone;

  factory DealerAccountBranch.fromJson(Map<String, dynamic> json) =>
      DealerAccountBranch(
        name: json["name"] == null ? null : json["name"],
        phone: json["phone"] == null ? null : json["phone"],
      );
}
