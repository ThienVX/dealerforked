import 'dart:io';

import 'package:dealer_app/constants/common_constants.dart';
import 'package:dealer_app/repositories/models/request_models/create_comlaint_request_model.dart';
import 'package:dealer_app/repositories/models/response_models/base_response_model.dart';
import 'package:dealer_app/repositories/models/response_models/dealer_brances_response_mode.dart';
import 'package:dealer_app/repositories/models/response_models/get_statistic_response_model.dart';
import 'package:dealer_app/utils/common_utils.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:http/http.dart';
import 'package:dealer_app/utils/extension_methods.dart';

abstract class TransactionNetwork {
  Future<GetStatisticResponseModel> getStatistic(
    String dealerId,
    DateTime fromDate,
    DateTime toDate,
    Client client,
  );
  Future<DealerBranchesResponseModel> getBranches(Client client);
  Future<BaseResponseModel> createComplaint(
      CreateComplaintequestModel requestModel, Client client);
}

class TransactionNetworkImpl implements TransactionNetwork {
  @override
  Future<GetStatisticResponseModel> getStatistic(
    String dealerId,
    DateTime fromDate,
    DateTime toDate,
    Client client,
  ) async {
    var response = await NetworkUtils.getNetworkWithBearer(
      uri: CustomApiUrl.getStatistic,
      client: client,
      queries: {
        'DealerAccountId': dealerId,
        'FromDate': fromDate.toOnlyDateString(),
        'ToDate': toDate.toOnlyDateString(),
      },
    );
    // get model
    var responseModel = await NetworkUtils
        .checkSuccessStatusCodeAPIMainResponseModel<GetStatisticResponseModel>(
      response,
      getStatisticResponseModelFromJson,
    );
    return responseModel;
  }

  @override
  Future<DealerBranchesResponseModel> getBranches(Client client) async {
    var response = await NetworkUtils.getNetworkWithBearer(
      uri: CustomApiUrl.getBranches,
      client: client,
    );
    // get model
    var responseModel =
        await NetworkUtils.checkSuccessStatusCodeAPIMainResponseModel<
            DealerBranchesResponseModel>(
      response,
      dealerBranchesResponseModelFromJson,
    );
    return responseModel;
  }

  @override
  Future<BaseResponseModel> createComplaint(
      CreateComplaintequestModel requestModel, Client client) async {
    var response = await NetworkUtils.postBodyWithBearerAuth(
      uri: CustomApiUrl.createComplaint,
      headers: {
        HttpHeaders.contentTypeHeader: NetworkConstants.applicationJson,
      },
      body: createComplaintRequestModelToJson(requestModel),
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
