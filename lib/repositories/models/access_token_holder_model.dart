// To parse this JSON data, do
//
//     final accessTokenHolder = accessTokenHolderFromJson(jsonString);

import 'dart:convert';

AccessTokenHolderModel accessTokenHolderFromJson(String str) =>
    AccessTokenHolderModel.fromJson(json.decode(str));

String accessTokenHolderToJson(AccessTokenHolderModel data) =>
    json.encode(data.toJson());

class AccessTokenHolderModel {
  AccessTokenHolderModel({
    required this.accessToken,
    required this.expiresIn,
    required this.tokenType,
    required this.refreshToken,
    required this.scope,
  });

  String accessToken;
  int expiresIn;
  String tokenType;
  String refreshToken;
  String scope;

  factory AccessTokenHolderModel.fromJson(Map<String, dynamic> json) =>
      AccessTokenHolderModel(
        accessToken: json["access_token"],
        expiresIn: json["expires_in"],
        tokenType: json["token_type"],
        refreshToken: json["refresh_token"],
        scope: json["scope"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "expires_in": expiresIn,
        "token_type": tokenType,
        "refresh_token": refreshToken,
        "scope": scope,
      };
}
