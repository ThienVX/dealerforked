// To parse this JSON data, do
//
//     final getBranchesResponseModel = getBranchesResponseModelFromJson(jsonString);

import 'dart:convert';

import '../get_branches_model.dart';

GetBranchesResponseModel getBranchesResponseModelFromJson(String str) =>
    GetBranchesResponseModel.fromJson(json.decode(str));

class GetBranchesResponseModel {
  GetBranchesResponseModel({
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
  List<GetBranchesModel> resData;

  factory GetBranchesResponseModel.fromJson(Map<String, dynamic> json) =>
      GetBranchesResponseModel(
        isSuccess: json["isSuccess"] == null ? null : json["isSuccess"],
        statusCode: json["statusCode"] == null ? null : json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"] == null ? null : json["total"],
        resData: List<GetBranchesModel>.from(
            json["resData"].map((x) => GetBranchesModel.fromJson(x))),
      );
}
