// To parse this JSON data, do
//
//     final collectDealTransactionModel = collectDealTransactionModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';

CollectDealTransactionModel collectDealTransactionModelFromJson(String str) =>
    CollectDealTransactionModel.fromJson(json.decode(str));

String collectDealTransactionModelToJson(CollectDealTransactionModel data) =>
    json.encode(data);

class CollectDealTransactionModel {
  CollectDealTransactionModel({
    required this.id,
    this.collectorImage,
    required this.collectorName,
    required this.transactionDateTime,
    required this.total,
    this.image,
  });

  String id;
  String? collectorImage;
  String collectorName;
  DateTime transactionDateTime;
  int total;

  ImageProvider? image;

  factory CollectDealTransactionModel.fromJson(Map<String, dynamic> json) =>
      CollectDealTransactionModel(
        id: json["id"],
        collectorImage: json["collectorImage"],
        collectorName: json["collectorName"],
        transactionDateTime: DateTime.parse(json["transactionDateTime"]),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "collectorImage": collectorImage,
        "collectorName": collectorName,
        "transactionDateTime": transactionDateTime.toIso8601String(),
        "total": total,
      };
}
