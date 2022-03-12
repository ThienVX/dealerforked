// To parse this JSON data, do
//
//     final infoReviewResponseModel = infoReviewResponseModelFromJson(jsonString);

import 'dart:convert';

import '../info_review_model.dart';

InfoReviewResponseModel infoReviewResponseModelFromJson(String str) =>
    InfoReviewResponseModel.fromJson(json.decode(str));

String infoReviewResponseModelToJson(InfoReviewResponseModel data) =>
    json.encode(data.toJson());

class InfoReviewResponseModel {
  InfoReviewResponseModel({
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
  InfoReviewModel? resData;

  factory InfoReviewResponseModel.fromJson(Map<String, dynamic> json) =>
      InfoReviewResponseModel(
        isSuccess: json["isSuccess"] == null ? null : json["isSuccess"],
        statusCode: json["statusCode"] == null ? null : json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData: json["resData"] == null
            ? null
            : InfoReviewModel.fromJson(json["resData"]),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess == null ? null : isSuccess,
        "statusCode": statusCode == null ? null : statusCode,
        "msgCode": msgCode,
        "msgDetail": msgDetail,
        "total": total,
        "resData": resData == null ? null : resData!.toJson(),
      };
}
