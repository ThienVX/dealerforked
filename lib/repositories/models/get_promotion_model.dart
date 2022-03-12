import 'package:flutter/cupertino.dart';

class GetPromotionModel {
  GetPromotionModel({
    required this.id,
    required this.code,
    required this.promotionName,
    required this.appliedScrapCategory,
    required this.appliedScrapCategoryImageUrl,
    required this.appliedAmount,
    required this.bonusAmount,
    required this.appliedFromTime,
    required this.appliedToTime,
    required this.status,
  });

  String id;
  String code;
  String promotionName;
  String appliedScrapCategory;
  String appliedScrapCategoryImageUrl;
  int appliedAmount;
  int bonusAmount;
  String appliedFromTime;
  String appliedToTime;
  int status;

  ImageProvider? image;

  factory GetPromotionModel.fromJson(Map<String, dynamic> json) =>
      GetPromotionModel(
        id: json["id"] == null ? null : json["id"],
        code: json["code"] == null ? null : json["code"],
        promotionName:
            json["promotionName"] == null ? null : json["promotionName"],
        appliedScrapCategory: json["appliedScrapCategory"] == null
            ? null
            : json["appliedScrapCategory"],
        appliedScrapCategoryImageUrl:
            json["appliedScrapCategoryImageUrl"] == null
                ? null
                : json["appliedScrapCategoryImageUrl"],
        appliedAmount:
            json["appliedAmount"] == null ? null : json["appliedAmount"],
        bonusAmount: json["bonusAmount"] == null ? null : json["bonusAmount"],
        appliedFromTime:
            json["appliedFromTime"] == null ? null : json["appliedFromTime"],
        appliedToTime:
            json["appliedToTime"] == null ? null : json["appliedToTime"],
        status: json["status"] == null ? null : json["status"],
      );
}
