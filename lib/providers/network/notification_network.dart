import 'package:dealer_app/repositories/models/response_models/base_response_model.dart';
import 'package:dealer_app/repositories/models/response_models/notification_get_response_model.dart';
import 'package:dealer_app/repositories/models/response_models/notification_unread_count_response_model.dart';
import 'package:dealer_app/utils/common_utils.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:http/http.dart';

abstract class NotificationNetwork {
  Future<NotificationGetResponseModel> getNotification(
    int page,
    int pageSize,
    Client client,
  );

  Future<NotificationUnreadCountResponseModel> getUnreadCount(Client client);

  Future<BaseResponseModel> readNotification(String id, Client client);
}

class NotificationNetworkImpl extends NotificationNetwork {
  @override
  Future<NotificationGetResponseModel> getNotification(
    int page,
    int pageSize,
    Client client,
  ) async {
    var response = await NetworkUtils.getNetworkWithBearer(
      uri: CustomApiUrl.notificationGet,
      client: client,
      queries: {
        'Page': page.toString(),
        'PageSize': pageSize.toString(),
      },
    );
    var responseModel =
        await NetworkUtils.checkSuccessStatusCodeAPIMainResponseModel<
            NotificationGetResponseModel>(
      response,
      notificationGetResponseModelFromJson,
    );
    // get model

    return responseModel;
  }

  @override
  Future<NotificationUnreadCountResponseModel> getUnreadCount(
      Client client) async {
    var response = await NetworkUtils.getNetworkWithBearer(
      uri: CustomApiUrl.notificationUnreadCount,
      client: client,
    );
    var responseModel =
        await NetworkUtils.checkSuccessStatusCodeAPIMainResponseModel<
            NotificationUnreadCountResponseModel>(
      response,
      notificationUnreadCountResponseModelFromJson,
    );

    return responseModel;
  }

  @override
  Future<BaseResponseModel> readNotification(String id, Client client) async {
    String url =
        NetworkUtils.toStringUrl(CustomApiUrl.notificationRead, {"id": id});

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
