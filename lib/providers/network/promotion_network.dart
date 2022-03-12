import 'dart:convert';
import 'dart:io';

import 'package:dealer_app/repositories/models/response_models/get_promotion_detail_response_model.dart';
import 'package:dealer_app/repositories/models/response_models/get_promotion_response_model.dart';
import 'package:dealer_app/utils/env_util.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:http/http.dart' as http;

class PromotionNetwork {
  static Future<bool> postPromotion({
    required String bearerToken,
    required String body,
  }) async {
    //add headers
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
    };

    final uri = Uri.http(
        EnvAppApiSettingValue.apiUrl, CustomApiUrl.apiUrlPostPromotion);

    final response = await http.post(
      uri,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      if (response.body.contains('400')) return false;
      // If the server did return a 200 OK response,
      return true;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(CustomAPIError.postCollectDealTransactionFailedException);
    }
  }

  static Future<GetPromotionResponseModel> getPromotion(
      {required String bearerToken}) async {
    //add headers
    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
    };
    final uri = Uri.http(
        EnvAppApiSettingValue.apiUrl, CustomApiUrl.apiUrlGetPromotions);

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return getPromotionResponseModelFromJson(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(CustomAPIError.getPromotionsFailedException);
    }
  }

  static Future<GetPromotionDetailResponseModel> getPromotionDetail({
    required String bearerToken,
    required String id,
  }) async {
    //add headers
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
    };
    Map<String, dynamic> queryParams = {
      'id': id,
    };

    final uri = Uri.http(EnvAppApiSettingValue.apiUrl,
        CustomApiUrl.apiUrlGetPromotionDetail, queryParams);

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return getPromotionDetailResponseModelFromJson(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(CustomAPIError.getPromotionDetailFailedException);
    }
  }

  static Future<Map<String, dynamic>> putPromotion({
    required String bearerToken,
    required String id,
  }) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
    };

    Map<String, dynamic> queryParams = {
      'id': id,
    };

    final uri = Uri.http(EnvAppApiSettingValue.apiUrl,
        CustomApiUrl.apiUrlPutPromotion, queryParams);

    final response = await http.put(uri, headers: headers);

    return jsonDecode(response.body);
  }
}
