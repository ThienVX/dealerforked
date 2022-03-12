import 'package:dealer_app/constants/common_constants.dart';
import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/providers/network/identity_server_network.dart';
import 'package:dealer_app/repositories/models/gender_model.dart';
import 'package:dealer_app/repositories/models/request_models/confirm_restore_password_request_model.dart';
import 'package:dealer_app/repositories/models/request_models/restore_pass_otp_request_model.dart';
import 'package:dealer_app/repositories/models/request_models/restore_password_request_model.dart';
import 'package:dealer_app/repositories/states/dealer_information_state.dart';
import 'package:dealer_app/repositories/states/profile_state.dart';
import 'package:dealer_app/utils/common_utils.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:http/http.dart';

abstract class IdentityServerService {
  Future<ProfileState?> getProfile();
  Future<int?> updatePassword(
      String id, String oldPassword, String newPassword);
  Future<bool> restorePassSendingOTP(String phoneNumber);

  Future<String> confirmOTPRestorePass(String phoneNumber, String otp);
  Future<int> restorePassword(
      String phoneNumber, String token, String newPassword);
  Future<DealerInformationState> getDealerInformation();
  Future<bool> changeDealerStatus(bool status);
}

class IdentityServerServiceImpl implements IdentityServerService {
  late final IdentityServerNetwork _identityServerNetwork;

  IdentityServerServiceImpl({IdentityServerNetwork? identityServerNetwork}) {
    _identityServerNetwork =
        identityServerNetwork ?? getIt.get<IdentityServerNetwork>();
  }
  @override
  Future<ProfileState?> getProfile() async {
    Client client = Client();
    ProfileState? result;
    var responseModel = await _identityServerNetwork
        .getAccountInfo(client)
        .whenComplete(() => client.close());
    var m = responseModel.resData;
    if (m != null) {
      String imageUrl = Symbols.empty;
      if (m.image != null && m.image!.isNotEmpty) {
        imageUrl = NetworkUtils.getUrlWithQueryString(
            CustomApiUrl.imageGet, {'imageUrl': m.image!});
      }
      result = ProfileState(
        id: m.id,
        name: m.name ?? Symbols.empty,
        address: m.address,
        birthDate: m.birthDate == null
            ? null
            : CommonUtils.convertDDMMYYYToDateTime(m.birthDate!),
        email: m.email,
        gender: m.gender == 1 ? Gender.male : Gender.female,
        image: imageUrl,
        phone: m.phone ?? Symbols.empty,
        totalPoint: m.totalPoint ?? 0,
        idCard: m.idCard ?? Symbols.empty,
        dealerType: m.roleKey ?? 0,
      );
    }

    return result;
  }

  @override
  Future<int?> updatePassword(
      String id, String oldPassword, String newPassword) async {
    Client client = Client();

    var result = await _identityServerNetwork
        .updatePassword(
          id,
          oldPassword,
          newPassword,
          client,
        )
        .whenComplete(() => client.close());

    return result;
  }

  @override
  Future<bool> restorePassSendingOTP(String phoneNumber) async {
    phoneNumber = CommonUtils.addZeroBeforePhoneNumber(phoneNumber);

    Client client = Client();
    var result = await _identityServerNetwork
        .restorePassOTP(
          RestorePassOtpRequestModel(phone: phoneNumber),
          client,
        )
        .whenComplete(() => client.close());

    return result.isSuccess && result.statusCode == NetworkConstants.ok200;
  }

  @override
  Future<String> confirmOTPRestorePass(String phoneNumber, String otp) async {
    Client client = Client();
    var result = await _identityServerNetwork
        .confirmRestorePassword(
          ConfirmRestorePasswordRequestModel(phone: phoneNumber, otp: otp),
          client,
        )
        .whenComplete(() => client.close());
    if (result.isSuccess &&
        result.statusCode == NetworkConstants.ok200 &&
        result.resData != null &&
        result.resData!.isNotEmpty) {
      return result.resData!;
    }
    return Symbols.empty;
  }

  @override
  Future<int> restorePassword(
      String phoneNumber, String token, String newPassword) async {
    Client client = Client();
    var result = await _identityServerNetwork
        .restorePassword(
          RestorePasswordRequestModel(
            phone: phoneNumber,
            newPassword: newPassword,
            token: token,
          ),
          client,
        )
        .whenComplete(() => client.close());

    if (result.isSuccess && result.statusCode == NetworkConstants.ok200) {
      return NetworkConstants.ok200;
    } else {
      return NetworkConstants.badRequest400;
    }
  }

  @override
  Future<DealerInformationState> getDealerInformation() async {
    Client client = Client();
    DealerInformationState result = await _identityServerNetwork
        .getDealerInfo(
      client,
    )
        .then<DealerInformationState>((responseModel) {
      var d = responseModel.resData;
      if (d != null) {
        String dealerImageUrl = Symbols.empty;
        if (d.dealerImageUrl != null && d.dealerImageUrl!.isNotEmpty) {
          dealerImageUrl = NetworkUtils.getUrlWithQueryString(
              CustomApiUrl.imageGet, {'imageUrl': d.dealerImageUrl!});
        }
        return DealerInformationState(
          id: d.id,
          dealerAddress: d.dealerAddress,
          dealerImageUrl: dealerImageUrl,
          dealerName: d.dealerName,
          dealerPhone: d.dealerPhone,
          dealerLatitude: d.dealerLatitude,
          dealerLongtitude: d.dealerLongtitude,
          openTime: d.openTime,
          closeTime: d.closeTime,
          isActive: d.isActive,
        );
      } else {
        return DealerInformationState();
      }
    }).whenComplete(() => client.close());

    return result;
  }

  @override
  Future<bool> changeDealerStatus(bool status) async {
    Client client = Client();
    var result = await _identityServerNetwork
        .changeStatusDealer(
      client,
      status,
    )
        .then(
      (responseModel) {
        return responseModel.isSuccess &&
            responseModel.statusCode == NetworkConstants.ok200;
      },
    ).whenComplete(
      () => client.close(),
    );
    return result;
  }
}
