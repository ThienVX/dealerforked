import 'dart:async';

import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/providers/network/login_network.dart';
import 'package:dealer_app/repositories/handlers/user_handler.dart';
import 'package:dealer_app/repositories/models/access_token_holder_model.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:dealer_app/utils/secure_storage.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

abstract class IAuthenticationHandler {
  Stream<AuthenticationStatus> get stream;
  Future<void> login({required String phone, required String password});
  void logout();
  void dispose();
  Future<void> autoLogin();
}

class AuthenticationHandler implements IAuthenticationHandler {
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get stream async* {
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> login({
    required String phone,
    required String password,
  }) async {
    try {
      final userHandler = getIt.get<IUserHandler>();
      //get access token
      AccessTokenHolderModel accessTokenHolderModel =
          await LoginNetwork.fectchAccessToken(
              phone: phone, password: password);
      //save token
      bool result = await SecureStorage.writeValue(
          key: CustomKeys.accessToken,
          value: accessTokenHolderModel.accessToken);
      //Save refresh token
      result = await SecureStorage.writeValue(
          key: CustomKeys.refreshToken,
          value: accessTokenHolderModel.refreshToken);
      if (result) {
        //put device Id
        result = await userHandler.putDeviceIdWhenLogin(
            bearerToken: accessTokenHolderModel.accessToken);
        if (result)
          //add event
          _controller.add(AuthenticationStatus.authenticated);
        else
          _controller.add(AuthenticationStatus.unauthenticated);
      } else
        _controller.add(AuthenticationStatus.unauthenticated);
    } catch (e) {
      _controller.add(AuthenticationStatus.unauthenticated);
      throw (e);
    }
  }

  void logout() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();

  Future<void> autoLogin() async {
    try {
      final userHandler = getIt.get<IUserHandler>();
      //get refresh token
      String? refreshToken =
          await SecureStorage.readValue(key: CustomKeys.refreshToken);
      if (refreshToken != null) {
        //get access token
        AccessTokenHolderModel accessTokenHolderModel =
            await LoginNetwork.refreshToken(refreshToken: refreshToken);
        //save token
        bool result = await SecureStorage.writeValue(
            key: CustomKeys.accessToken,
            value: accessTokenHolderModel.accessToken);
        //Save refresh token
        result = await SecureStorage.writeValue(
            key: CustomKeys.refreshToken,
            value: accessTokenHolderModel.refreshToken);
        if (result) {
          //put device Id
          result = await userHandler.putDeviceIdWhenLogin(
              bearerToken: accessTokenHolderModel.accessToken);
          if (result)
            //add event
            _controller.add(AuthenticationStatus.authenticated);
          else
            _controller.add(AuthenticationStatus.unauthenticated);
        } else
          _controller.add(AuthenticationStatus.unauthenticated);
      } else {
        _controller.add(AuthenticationStatus.unauthenticated);
      }
    } catch (e) {
      _controller.add(AuthenticationStatus.unauthenticated);
      throw (e);
    }
  }
}
