class GetBranchesModel {
  GetBranchesModel({
    required this.id,
    required this.dealerBranchName,
    required this.dealerBranchImageUrl,
    required this.dealerBranchAddress,
  });

  String id;
  String dealerBranchName;
  String dealerBranchImageUrl;
  String dealerBranchAddress;

  factory GetBranchesModel.fromJson(Map<String, dynamic> json) =>
      GetBranchesModel(
        id: json["id"] == null ? null : json["id"],
        dealerBranchName:
            json["dealerBranchName"] == null ? null : json["dealerBranchName"],
        dealerBranchImageUrl: json["dealerBranchImageUrl"] == null
            ? null
            : json["dealerBranchImageUrl"],
        dealerBranchAddress: json["dealerBranchAddress"] == null
            ? null
            : json["dealerBranchAddress"],
      );
}
