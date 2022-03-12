import 'dart:convert';

import 'package:dealer_app/repositories/models/response_models/base_response_model.dart';

NotificationUnreadCountResponseModel
    notificationUnreadCountResponseModelFromJson(String str) =>
        NotificationUnreadCountResponseModel.fromJson(json.decode(str));

class NotificationUnreadCountResponseModel extends BaseResponseModel {
  NotificationUnreadCountResponseModel({
    required bool isSuccess,
    required int statusCode,
    this.msgCode,
    this.msgDetail,
    required this.total,
    required this.resData,
  }) : super(
          isSuccess: isSuccess,
          statusCode: statusCode,
        );

  dynamic msgCode;
  dynamic msgDetail;
  int total;
  int resData;

  factory NotificationUnreadCountResponseModel.fromJson(
          Map<String, dynamic> json) =>
      NotificationUnreadCountResponseModel(
        isSuccess: json["isSuccess"],
        statusCode: json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData: json["resData"],
      );
}
