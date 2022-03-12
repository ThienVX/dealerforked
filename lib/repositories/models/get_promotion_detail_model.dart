class GetPromotionDetailModel {
  GetPromotionDetailModel({
    required this.code,
    required this.promotionName,
    required this.appliedScrapCategory,
    required this.appliedAmount,
    required this.bonusAmount,
    required this.appliedFromTime,
    required this.appliedToTime,
  });

  String code;
  String promotionName;
  String appliedScrapCategory;
  int appliedAmount;
  int bonusAmount;
  String appliedFromTime;
  String appliedToTime;

  factory GetPromotionDetailModel.fromJson(Map<String, dynamic> json) =>
      GetPromotionDetailModel(
        code: json["code"] == null ? null : json["code"],
        promotionName:
            json["promotionName"] == null ? null : json["promotionName"],
        appliedScrapCategory: json["appliedScrapCategory"] == null
            ? null
            : json["appliedScrapCategory"],
        appliedAmount:
            json["appliedAmount"] == null ? null : json["appliedAmount"],
        bonusAmount: json["bonusAmount"] == null ? null : json["bonusAmount"],
        appliedFromTime:
            json["appliedFromTime"] == null ? null : json["appliedFromTime"],
        appliedToTime:
            json["appliedToTime"] == null ? null : json["appliedToTime"],
      );
}
