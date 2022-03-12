import 'dart:convert';

String createComplaintRequestModelToJson(CreateComplaintequestModel data) =>
    json.encode(data.toJson());

class CreateComplaintequestModel {
  CreateComplaintequestModel({
    required this.collectDealTransactionId,
    required this.complaintContent,
  });

  String collectDealTransactionId;
  String complaintContent;

  Map<String, dynamic> toJson() => {
        "collectDealTransactionId": collectDealTransactionId,
        "complaintContent": complaintContent,
      };
}
