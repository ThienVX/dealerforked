import 'dart:convert';

import 'package:dealer_app/repositories/models/access_token_holder_model.dart';
import 'package:dealer_app/utils/env_util.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:http/http.dart' as http;

class LoginNetwork {
  static Future<AccessTokenHolderModel> fectchAccessToken(
      {required String phone, required String password}) async {
    String scope = EnvID4AppSettingValue.scopeRole +
        ' ' +
        EnvID4AppSettingValue.scopeIdCard +
        ' ' +
        EnvID4AppSettingValue.scopeOfflineAccess +
        ' ' +
        EnvID4AppSettingValue.scopeOpenId +
        ' ' +
        EnvID4AppSettingValue.scopePhone +
        ' ' +
        EnvID4AppSettingValue.scopeProfile +
        ' ' +
        EnvID4AppSettingValue.scopeResource +
        ' ' +
        EnvID4AppSettingValue.scopeEmail;
    Map<String, dynamic> body = {
      'client_id': EnvID4AppSettingValue.clientId,
      'client_secret': EnvID4AppSettingValue.clientSecret,
      'grant_type': EnvID4AppSettingValue.grantTypePassword,
      'username': phone,
      'password': password,
      'scope': scope
    };
    final response = await http.post(
        Uri.parse(EnvID4AppSettingValue.apiUrl + CustomApiUrl.apiUrlTokenLink),
        body: body);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return AccessTokenHolderModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      throw Exception(CustomAPIError.fetchTokenFailedException);
    } else {
      throw Exception(CustomAPIError.loginFailedException);
    }
  }

  static Future<AccessTokenHolderModel> refreshToken(
      {required String refreshToken}) async {
    String scope = EnvID4AppSettingValue.scopeRole +
        ' ' +
        EnvID4AppSettingValue.scopeIdCard +
        ' ' +
        EnvID4AppSettingValue.scopeOfflineAccess +
        ' ' +
        EnvID4AppSettingValue.scopeOpenId +
        ' ' +
        EnvID4AppSettingValue.scopePhone +
        ' ' +
        EnvID4AppSettingValue.scopeProfile +
        ' ' +
        EnvID4AppSettingValue.scopeResource +
        ' ' +
        EnvID4AppSettingValue.scopeEmail;
    Map<String, dynamic> body = {
      'client_id': EnvID4AppSettingValue.clientId,
      'client_secret': EnvID4AppSettingValue.clientSecret,
      'grant_type': EnvID4AppSettingValue.grantTypeRefreshToken,
      'scope': scope,
      'refresh_token': refreshToken,
    };
    final response = await http.post(
        Uri.parse(EnvID4AppSettingValue.apiUrl + CustomApiUrl.apiUrlTokenLink),
        body: body);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return AccessTokenHolderModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      throw Exception(CustomAPIError.fetchTokenFailedException);
    } else {
      throw Exception(CustomAPIError.refreshTokenException);
    }
  }
}
