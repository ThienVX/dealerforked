// To parse this JSON data, do
//
//     final infoReviewModel = infoReviewModelFromJson(jsonString);

import 'dart:convert';

InfoReviewModel infoReviewModelFromJson(String str) =>
    InfoReviewModel.fromJson(json.decode(str));

String infoReviewModelToJson(InfoReviewModel data) =>
    json.encode(data.toJson());

class InfoReviewModel {
  InfoReviewModel({
    required this.collectorId,
    required this.collectorName,
    required this.collectorPhone,
    required this.transactionFeePercent,
  });

  String collectorId;
  String collectorName;
  String collectorPhone;
  int transactionFeePercent;

  factory InfoReviewModel.fromJson(Map<String, dynamic> json) =>
      InfoReviewModel(
        collectorId: json["collectorId"] == null ? null : json["collectorId"],
        collectorName:
            json["collectorName"] == null ? null : json["collectorName"],
        collectorPhone:
            json["collectorPhone"] == null ? null : json["collectorPhone"],
        transactionFeePercent: json["transactionFeePercent"] == null
            ? null
            : json["transactionFeePercent"],
      );

  Map<String, dynamic> toJson() => {
        "collectorId": collectorId,
        "collectorName": collectorName,
        "collectorPhone": collectorPhone,
        "transactionFeePercent": transactionFeePercent,
      };
}
