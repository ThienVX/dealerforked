import 'dart:convert';

import 'package:dealer_app/repositories/models/response_models/base_response_model.dart';

DealerBranchesResponseModel dealerBranchesResponseModelFromJson(String str) =>
    DealerBranchesResponseModel.fromJson(json.decode(str));

class DealerBranchesResponseModel extends BaseResponseModel {
  DealerBranchesResponseModel({
    required bool isSuccess,
    required int statusCode,
    this.msgCode,
    this.msgDetail,
    this.total,
    this.resData,
  }) : super(
          isSuccess: isSuccess,
          statusCode: statusCode,
        );
  dynamic msgCode;
  dynamic msgDetail;
  int? total;
  List<ResDatum>? resData;

  factory DealerBranchesResponseModel.fromJson(Map<String, dynamic> json) =>
      DealerBranchesResponseModel(
        isSuccess: json["isSuccess"],
        statusCode: json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData: List<ResDatum>.from(
            json["resData"].map((x) => ResDatum.fromJson(x))),
      );
}

class ResDatum {
  ResDatum({
    required this.dealerAccountId,
    required this.dealerName,
  });

  final String dealerAccountId;
  final String dealerName;

  factory ResDatum.fromJson(Map<String, dynamic> json) => ResDatum(
        dealerAccountId: json["dealerAccountId"],
        dealerName: json["dealerName"],
      );
}
