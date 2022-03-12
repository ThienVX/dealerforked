import 'dart:convert';

import 'package:dealer_app/repositories/models/collect_deal_transaction_detail_model.dart';

String collectDealTransactionRequestModelToJson(
        CollectDealTransactionRequestModel data) =>
    json.encode(data.toJson());

class CollectDealTransactionRequestModel {
  CollectDealTransactionRequestModel({
    required this.collectorId,
    required this.transactionFee,
    required this.total,
    required this.totalBonus,
    required this.items,
  });

  String collectorId;
  int transactionFee;
  int total;
  int totalBonus;
  List<CollectDealTransactionDetailModel> items;

  Map<String, dynamic> toJson() => {
        "collectorId": collectorId,
        "transactionFee": transactionFee,
        "total": total,
        "totalBonus": totalBonus,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}
