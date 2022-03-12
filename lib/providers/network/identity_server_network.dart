import 'dart:io';

import 'package:dealer_app/constants/common_constants.dart';
import 'package:dealer_app/repositories/models/request_models/confirm_restore_password_request_model.dart';
import 'package:dealer_app/repositories/models/request_models/restore_pass_otp_request_model.dart';
import 'package:dealer_app/repositories/models/request_models/restore_password_request_model.dart';
import 'package:dealer_app/repositories/models/response_models/base_response_model.dart';
import 'package:dealer_app/repositories/models/response_models/confirm_restore_password_response_model.dart';
import 'package:dealer_app/repositories/models/response_models/dealer_information_response_model.dart';
import 'package:dealer_app/repositories/models/response_models/profile_info_response_model.dart';
import 'package:dealer_app/utils/common_utils.dart';
import 'package:dealer_app/utils/env_util.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:http/http.dart';

abstract class IdentityServerNetwork {
  Future<ProfileInfoResponseModel> getAccountInfo(Client client);

  Future<int?> updatePassword(
    String id,
    String oldPassword,
    String newPassword,
    Client client,
  );

  Future<BaseResponseModel> restorePassOTP(
    RestorePassOtpRequestModel requestModel,
    Client client,
  );

  Future<ConfirmRestorePasswordResponseModel> confirmRestorePassword(
    ConfirmRestorePasswordRequestModel requestModel,
    Client client,
  );

  Future<BaseResponseModel> restorePassword(
    RestorePasswordRequestModel requestModel,
    Client client,
  );
  Future<DealerInformationResponseModel> getDealerInfo(Client client);
  Future<BaseResponseModel> changeStatusDealer(Client client, bool value);
}

class IdentityServerNetworkImpl implements IdentityServerNetwork {
  @override
  Future<ProfileInfoResponseModel> getAccountInfo(Client client) async {
    var response = await NetworkUtils.getNetworkWithBearer(
      uri: CustomApiUrl.accountCollectorInfo,
      client: client,
    );
    // get model
    var responseModel = await NetworkUtils
        .checkSuccessStatusCodeAPIMainResponseModel<ProfileInfoResponseModel>(
      response,
      profileInfoResponseModelFromJson,
    );
    return responseModel;
  }

  @override
  Future<int?> updatePassword(
    String id,
    String oldPassword,
    String newPassword,
    Client client,
  ) async {
    var body = <String, String>{
      'Id': id,
      'OldPassword': oldPassword,
      'NewPassword': newPassword,
    };
    //send request
    var response = await NetworkUtils.postBody(
      uri: IdentityAPIConstants.urlChangePassword,
      headers: {
        IdentityAPIConstants.clientIdParamName: EnvID4AppSettingValue.clientId,
      },
      body: body,
      client: client,
    );

    // convert
    // ignore: prefer_typing_uninitialized_variables
    BaseResponseModel responseModel;
    if (response.statusCode == NetworkConstants.ok200) {
      responseModel = BaseResponseModel.fromJson(
        await NetworkUtils.getMapFromResponse(response),
      );
      if (responseModel.isSuccess) {
        return NetworkConstants.ok200;
      } else {
        return NetworkConstants.badRequest400;
      }
    }

    return null;
  }

  @override
  Future<BaseResponseModel> restorePassOTP(
      RestorePassOtpRequestModel requestModel, Client client) async {
    var response = await NetworkUtils.postBody(
      uri: CustomApiUrl.restorePassOTP,
      headers: {
        HttpHeaders.contentTypeHeader: NetworkConstants.applicationJson,
      },
      body: restorePassOtpRequestModelToJson(
        requestModel,
      ),
      client: client,
    );

    var responseModel =
        await NetworkUtils.getModelOfResponseMainAPI<BaseResponseModel>(
      response,
      baseResponseModelFromJson,
    );

    return responseModel;
  }

  @override
  Future<ConfirmRestorePasswordResponseModel> confirmRestorePassword(
    ConfirmRestorePasswordRequestModel requestModel,
    Client client,
  ) async {
    var response = await NetworkUtils.postBody(
      uri: CustomApiUrl.confirmRestorePassOTP,
      headers: {
        IdentityAPIConstants.clientIdParamName: EnvID4AppSettingValue.clientId,
      },
      body: requestModel.toJson(),
      client: client,
    );

    var responseModel = await NetworkUtils.getModelOfResponseMainAPI<
        ConfirmRestorePasswordResponseModel>(
      response,
      confirmRestorePasswordResponseModelFromJson,
    );

    return responseModel;
  }

  @override
  Future<BaseResponseModel> restorePassword(
    RestorePasswordRequestModel requestModel,
    Client client,
  ) async {
    var response = await NetworkUtils.postBody(
      uri: CustomApiUrl.restorePassword,
      headers: {
        IdentityAPIConstants.clientIdParamName: EnvID4AppSettingValue.clientId,
      },
      body: requestModel.toJson(),
      client: client,
    );

    var responseModel =
        await NetworkUtils.getModelOfResponseMainAPI<BaseResponseModel>(
      response,
      baseResponseModelFromJson,
    );

    return responseModel;
  }

  Future<DealerInformationResponseModel> getDealerInfo(Client client) async {
    var response = await NetworkUtils.getNetworkWithBearer(
      uri: CustomApiUrl.dealerInformation,
      client: client,
    );
    var responseModel =
        await NetworkUtils.checkSuccessStatusCodeAPIMainResponseModel<
            DealerInformationResponseModel>(
      response,
      dealerInformationResponseModelFromJson,
    );

    return responseModel;
  }

  @override
  Future<BaseResponseModel> changeStatusDealer(
      Client client, bool value) async {
    String url = NetworkUtils.toStringUrl(
        CustomApiUrl.changeStatusDealer, {"status": value.toString()});

    var response = await NetworkUtils.putBodyWithBearerAuth(
      uri: url,
      client: client,
    );
    var responseModel = await NetworkUtils
        .checkSuccessStatusCodeAPIMainResponseModel<BaseResponseModel>(
      response,
      baseResponseModelFromJson,
    );

    return responseModel;
  }
}
