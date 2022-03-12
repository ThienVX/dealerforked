import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dealer_app/repositories/models/response_models/category_unit_response_model.dart';
import 'package:dealer_app/repositories/models/response_models/category_response_model.dart';
import 'package:dealer_app/repositories/models/response_models/collector_phone_response_model.dart';
import 'package:dealer_app/utils/env_util.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:http/http.dart' as http;

class DataNetWork {
  static Future<ScrapCategoryResponseModel> getScrapCategories(
      {required String bearerToken}) async {
    //add headers
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
    };
    final uri = Uri.http(EnvAppApiSettingValue.apiUrl,
        CustomApiUrl.apiUrlGetScrapCategoriesFromData);

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return ScrapCategoryResponseModel.fromJsonToCreateTransactionModel(
          jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(CustomAPIError.getScrapCategoriesFailedException);
    }
  }

  static Future<ScrapCategoryUnitResponseModel> getScrapCategoryDetails({
    required String bearerToken,
    required String scrapCategoryId,
  }) async {
    //add headers
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
    };
    Map<String, String> queryParams = {
      'id': scrapCategoryId,
    };

    final uri = Uri.http(EnvAppApiSettingValue.apiUrl,
        CustomApiUrl.apiUrlGetScrapCategoryDetails, queryParams);

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return ScrapCategoryUnitResponseModel.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(CustomAPIError.getScrapCategoryDetailsFailedException);
    }
  }

  static Future<CollectorPhoneResponseModel> getCollectorPhones({
    required String bearerToken,
  }) async {
    //add headers
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
    };

    final uri = Uri.http(
        EnvAppApiSettingValue.apiUrl, CustomApiUrl.apiUrlGetCollectorPhones);

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return CollectorPhoneResponseModel.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(CustomAPIError.getCollectorPhonesFailedException);
    }
  }

  static Future<Uint8List> getImageBytes({
    required String bearerToken,
    required String imageUrl,
  }) async {
    //add headers
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
    };
    Map<String, dynamic> queryParams = {
      'imageUrl': imageUrl,
    };

    final uri = Uri.http(
        EnvAppApiSettingValue.apiUrl, CustomApiUrl.apiUrlGetImage, queryParams);

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return response.bodyBytes;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(CustomAPIError.getImageFailedException);
    }
  }
}
