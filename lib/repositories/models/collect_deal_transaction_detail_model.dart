import 'package:dealer_app/utils/param_util.dart';

class CollectDealTransactionDetailModel {
  String dealerCategoryId;
  String? dealerCategoryDetailId;
  double quantity;
  String? unit;
  String? promotionId;
  int bonusAmount;
  int total;
  int price;

  bool isCalculatedByUnitPrice;
  bool isPromotionnApplied;

  int get totalCalculated {
    if (isCalculatedByUnitPrice && price != 0)
      return (price * quantity).truncate();
    else
      return 0;
  }

  CollectDealTransactionDetailModel({
    required this.dealerCategoryId,
    this.dealerCategoryDetailId,
    required this.quantity,
    this.unit,
    this.promotionId,
    required this.bonusAmount,
    required this.total,
    required this.price,
    required this.isCalculatedByUnitPrice,
    this.isPromotionnApplied = false,
  });

  Map<String, dynamic> toJson() => {
        "dealerCategoryDetailId": dealerCategoryDetailId == null
            ? CustomVar.unnamedScrapCategory.id
            : dealerCategoryDetailId,
        "quantity": quantity,
        "promotionId": promotionId == null
            ? CustomVar.noPromotion.promotionId
            : promotionId,
        "bonusAmount": bonusAmount,
        "total": total,
        "price": price,
      };
}
