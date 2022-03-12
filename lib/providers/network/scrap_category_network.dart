import 'dart:convert';
import 'dart:io';

import 'package:dealer_app/repositories/models/response_models/category_detail_response_model.dart';
import 'package:dealer_app/repositories/models/response_models/category_response_model.dart';
import 'package:dealer_app/repositories/models/response_models/upload_image_response_model.dart';
import 'package:dealer_app/utils/env_util.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:http/http.dart' as http;

class ScrapCategoryNetWork {
  static Future<UploadImageResponseModel> postImage({
    required String bearerToken,
    required String imagePath,
  }) async {
    //add headers
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
    };

    final uri =
        Uri.http(EnvAppApiSettingValue.apiUrl, CustomApiUrl.apiUrlPostImage);

    // Create multipart request
    var request = http.MultipartRequest("POST", uri);

    // Create multipart file
    var multipartFile = await http.MultipartFile.fromPath('Image', imagePath);

    // Add headers and files
    request.headers.addAll(headers);
    request.files.add(multipartFile);

    // Send request
    var streamedResponse = await request.send();

    // Get response from Streamed Response
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return uploadImageResponseModelFromJson(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(CustomAPIError.postImageFailedException);
    }
  }

  static Future<Map<String, dynamic>> getCheckScrapName({
    required String bearerToken,
    required String name,
  }) async {
    //add headers
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
    };
    Map<String, dynamic> queryParams = {
      'name': name,
    };

    final uri = Uri.http(EnvAppApiSettingValue.apiUrl,
        CustomApiUrl.apiUrlGetCheckScrapCategoryName, queryParams);

    final response = await http.get(uri, headers: headers);

    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> postScrapCategory({
    required String bearerToken,
    required String body,
  }) async {
    //add headers
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
    };

    final uri = Uri.http(
        EnvAppApiSettingValue.apiUrl, CustomApiUrl.apiUrlPostScrapCategory);

    final response = await http.post(
      uri,
      headers: headers,
      body: body,
    );

    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> putScrapCategory({
    required String bearerToken,
    required String body,
  }) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $bearerToken',
    };
    final uri = Uri.http(
        EnvAppApiSettingValue.apiUrl, CustomApiUrl.apiUrlPutScrapCategory);

    final response = await http.put(uri, headers: headers, body: body);

    return json.decode(response.body);
  }

  static Future<ScrapCategoryResponseModel> getScrapCategories({
    required String bearerToken,
    String? page,
    String? pageSize,
  }) async {
    //add headers
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
    };
    Map<String, dynamic> queryParams = {};
    if (page != null) queryParams.putIfAbsent('Page', () => page);
    if (pageSize != null) queryParams.putIfAbsent('PageSize', () => pageSize);

    final uri = Uri.http(EnvAppApiSettingValue.apiUrl,
        CustomApiUrl.apiUrlGetScrapCategoriesFromScrapCategory, queryParams);

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return responseModelFromJsonToCategoryListModel(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(CustomAPIError.getScrapCategoriesFailedException);
    }
  }

  static Future<ScrapCategoryDetailResponseModel> getScrapCategoryDetail({
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
        CustomApiUrl.apiUrlGetScrapCategorDetailFromScrapCategory, queryParams);

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return scrapCategoryDetailResponseModelFromJson(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(CustomAPIError.getScrapCategoryDetailsFailedException);
    }
  }

  static Future<Map<String, dynamic>> deleteScrapCategory({
    required String bearerToken,
    required String id,
  }) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
    };
    Map<String, dynamic> params = {
      'id': id,
    };

    final uri = Uri.http(EnvAppApiSettingValue.apiUrl,
        CustomApiUrl.apiUrlDeleteScrapCategory, params);

    final response = await http.delete(uri, headers: headers);

    return json.decode(response.body);
  }
}
