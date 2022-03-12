import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/providers/network/account_network.dart';
import 'package:dealer_app/providers/services/firebase_service.dart';
import 'package:dealer_app/repositories/models/response_models/dealer_response_model.dart';

abstract class IUserHandler {
  Future<DealerResponseModel?> getUser({required String bearerToken});
  Future<bool> putDeviceIdWhenLogin({required String bearerToken});
}

class UserHandler implements IUserHandler {
  Future<DealerResponseModel?> getUser({required String bearerToken}) async {
    DealerResponseModel? _responseModel =
        await AccountNetwork.getDealerInfo(bearerToken: bearerToken);
    return _responseModel;
  }

  Future<bool> putDeviceIdWhenLogin({required String bearerToken}) async {
    final firebase = getIt.get<FirebaseNotification>();
    //Get Device Id
    var _deviceId = await firebase.getToken();
    if (_deviceId != null) {
      return await AccountNetwork.putDeviceId(
          bearerToken: bearerToken, deivceId: _deviceId);
    } else
      return false;
  }
}
