import 'dart:convert';

import 'package:dealer_app/utils/param_util.dart';

import '../scrap_category_model.dart';

String createScrapCategoryRequestModelToJson(
        CreateScrapCategoryRequestModel data) =>
    json.encode(data.toJson());

class CreateScrapCategoryRequestModel {
  CreateScrapCategoryRequestModel({
    this.id = CustomTexts.emptyString,
    required this.name,
    required this.imageUrl,
    required this.details,
  });

  String id;
  String name;
  String imageUrl;
  List<ScrapCategoryModel> details;

  Map<String, dynamic> toJson() => {
        "name": name,
        "imageUrl": imageUrl,
        "details": List<dynamic>.from(
            details.map((x) => x.createCategoryModelToJson())),
      };
}
