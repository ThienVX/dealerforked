class CDTransactionHistoryDetailItemModel {
  CDTransactionHistoryDetailItemModel({
    required this.scrapCategoryName,
    required this.quantity,
    required this.unit,
    required this.total,
    required this.isBonus,
    required this.bonusAmount,
  });

  String? scrapCategoryName;
  double quantity;
  String? unit;
  int total;
  bool isBonus;
  int bonusAmount;

  factory CDTransactionHistoryDetailItemModel.fromJson(
          Map<String, dynamic> json) =>
      CDTransactionHistoryDetailItemModel(
        scrapCategoryName: json["scrapCategoryName"],
        quantity: json["quantity"].toDouble(),
        unit: json['unit'],
        total: json["total"],
        isBonus: json["isBonus"],
        bonusAmount: json["bonusAmount"],
      );
}
