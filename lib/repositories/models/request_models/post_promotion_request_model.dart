import 'dart:convert';

String postPromotionRequestModelToJson(PostPromotionRequestModel data) =>
    json.encode(data.toJson());

class PostPromotionRequestModel {
  PostPromotionRequestModel({
    required this.promotionName,
    required this.promotionScrapCategoryId,
    required this.appliedAmount,
    required this.bonusAmount,
    required this.appliedFromTime,
    required this.appliedToTime,
  });

  String promotionName;
  String promotionScrapCategoryId;
  int appliedAmount;
  int bonusAmount;
  DateTime appliedFromTime;
  DateTime appliedToTime;

  Map<String, dynamic> toJson() => {
        "promotionName": promotionName,
        "promotionScrapCategoryId": promotionScrapCategoryId,
        "appliedAmount": appliedAmount,
        "bonusAmount": bonusAmount,
        "appliedFromTime": appliedFromTime.toIso8601String(),
        "appliedToTime": appliedToTime.toIso8601String(),
      };
}
