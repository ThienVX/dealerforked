import 'dart:convert';
import 'dart:io';
import 'package:dealer_app/constants/common_constants.dart';
import 'package:dealer_app/exceptions/custom_exceptions.dart';
import 'package:dealer_app/log/logger.dart';
import 'package:dealer_app/repositories/models/response_models/base_response_model.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:dealer_app/utils/secure_storage.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class CommonUtils {
  static DateTime? convertDDMMYYYToDateTime(String date) {
    DateTime? result;
    try {
      DateFormat format = DateFormat(Others.ddMMyyyyPattern);
      result = format.parse(date);
    } catch (e) {
      AppLog.error('Exception at convertDDMMYYYToDateTime');
    }
    return result;
  }

  static String addZeroBeforePhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 9) {
      phoneNumber = '0$phoneNumber';
    }

    return phoneNumber;
  }

  static String toStringDDMMYYY(DateTime date) {
    return DateFormat(Others.ddMMyyyyPattern).format(date);
  }

  static String toStringPadleft(int number, int width) {
    return number.toString().padLeft(width, '0');
  }
}

class NetworkUtils {
  static String toStringUrl(String uri, Map<String, dynamic>? queries) {
    var uRI = Uri.parse(uri).replace(queryParameters: queries);
    return uRI.toString();
  }

  static Future<Response> postBodyWithBearerAuth({
    required String uri,
    Map<String, String>? headers,
    Object? body,
    required Client client,
  }) async {
    var mainHeader = <String, String>{
      HttpHeaders.authorizationHeader: await getBearerToken(),
    };

    if (headers != null) {
      mainHeader.addAll(headers);
    }

    return await postBody(
      uri: uri,
      headers: mainHeader,
      body: body,
      client: client,
    );
  }

  static Future<Map<String, dynamic>> getMapFromResponse(
      Response response) async {
    return jsonDecode(response.body);
  }

  static Future<Response> postBody({
    required String uri,
    Map<String, String>? headers,
    Object? body,
    required Client client,
  }) async {
    var response = client.post(
      Uri.parse(
        uri,
      ),
      body: body,
      headers: headers,
    );
    return response;
  }

  static String getUrlWithQueryString(String uri, Map<String, String> queries) {
    // ignore: non_constant_identifier_names
    var URI = Uri.parse(uri);
    URI = URI.replace(queryParameters: queries);
    return URI.toString();
  }

  static Future<String> getBearerToken() async {
    var accessToken =
        await SecureStorage.readValue(key: CustomKeys.accessToken);
    if (accessToken != null) {
      return 'Bearer $accessToken';
    } else {
      throw Exception(CustomAPIError.missingBearerToken);
    }
  }

  static Future<Response> putBodyWithBearerAuth({
    required String uri,
    Map<String, String>? headers,
    Object? body,
    required Client client,
  }) async {
    var accessToken =
        await SecureStorage.readValue(key: CustomKeys.accessToken);
    if (accessToken != null) {
      var mainHeader = <String, String>{
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      };

      if (headers != null) {
        mainHeader.addAll(headers);
      }

      return await putBody(
        uri: uri,
        headers: mainHeader,
        body: body,
        client: client,
      );
    } else {
      throw Exception(CustomAPIError.missingBearerToken);
    }
  }

  static Future<Response> putBody({
    required String uri,
    Map<String, String>? headers,
    Object? body,
    required Client client,
  }) async {
    var response = client.put(
      Uri.parse(
        uri,
      ),
      body: body,
      headers: headers,
    );
    return response;
  }

  static Future<Response> getNetworkWithBearer({
    required String uri,
    Map<String, String>? headers,
    Map<String, dynamic>? queries,
    required Client client,
  }) async {
    var accessToken =
        await SecureStorage.readValue(key: CustomKeys.accessToken);
    if (accessToken != null) {
      var newHeaders = <String, String>{
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      }..addAll(headers ?? {});

      return await getNetwork(
        uri: uri,
        headers: newHeaders,
        client: client,
        queries: queries,
      );
    } else {
      throw Exception(CustomAPIError.missingBearerToken);
    }
  }

  static Future<Response> getNetwork({
    required String uri,
    Map<String, String>? headers,
    Map<String, dynamic>? queries,
    required Client client,
  }) async {
    var url = Uri.parse(uri).replace(
      queryParameters: queries,
    );

    //create request
    var response = await client.get(
      url,
      headers: headers,
    );

    //add header

    return response;
  }

  static Future<T>
      checkSuccessStatusCodeAPIMainResponseModel<T extends BaseResponseModel>(
    Response response,
    T Function(String) convertJson,
  ) async {
    var responseModel = await NetworkUtils.getModelOfResponseMainAPI<T>(
      response,
      convertJson,
    );

    if (responseModel.statusCode == NetworkConstants.ok200 &&
        responseModel.isSuccess) return responseModel;

    //
    throw Exception();
  }

  static Future<T> getModelOfResponseMainAPI<T>(
      Response response, T Function(String) convert) async {
    switch (response.statusCode) {
      case NetworkConstants.ok200:
        T model = convert(response.body);
        return model;
      case NetworkConstants.unauthorized401:
        throw UnauthorizedException();
      default:
        throw Exception();
    }
  }
}
