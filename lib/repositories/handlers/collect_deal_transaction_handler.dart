import 'package:dealer_app/providers/network/account_network.dart';
import 'package:dealer_app/providers/network/collect_deal_transaction_network.dart';
import 'package:dealer_app/repositories/models/collect_deal_transaction_history_detail_model.dart';
import 'package:dealer_app/repositories/models/collect_deal_transaction_model.dart';
import 'package:dealer_app/repositories/models/info_review_model.dart';
import 'package:dealer_app/repositories/models/request_models/collect_deal_transaction_request_model.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:dealer_app/utils/secure_storage.dart';

abstract class ICollectDealTransactionHandler {
  Future<InfoReviewModel?> getInfoReview({required String collectorId});
  Future<String?> createCollectDealTransaction(
      {required CollectDealTransactionRequestModel model});
  Future<List<CollectDealTransactionModel>> getCollectDealHistories({
    DateTime? fromDate,
    DateTime? toDate,
    int? fromTotal,
    int? toTotal,
    int? page,
    int? pageSize,
  });
  Future<CDTransactionHistoryDetailModel> getCollectDealHistoryDetail({
    required String id,
  });
}

class CollectDealTransactionHandler implements ICollectDealTransactionHandler {
  Future<InfoReviewModel?> getInfoReview({required String collectorId}) async {
    try {
      //get access token
      var accessToken =
          await SecureStorage.readValue(key: CustomKeys.accessToken);
      if (accessToken != null) {
        var infoReview = (await CollectDealTransactionNetWork.getInfoReview(
          bearerToken: accessToken,
          collectorId: collectorId,
        ))
            .resData;
        //get info review
        return infoReview;
      } else
        throw Exception(CustomAPIError.missingBearerToken);
    } catch (e) {
      throw (e);
    }
  }

  Future<String?> createCollectDealTransaction(
      {required CollectDealTransactionRequestModel model}) async {
    try {
      //get access token
      var accessToken =
          await SecureStorage.readValue(key: CustomKeys.accessToken);
      if (accessToken != null) {
        var result =
            await CollectDealTransactionNetWork.postCollectDealTransaction(
          bearerToken: accessToken,
          body: collectDealTransactionRequestModelToJson(model),
        );
        //get info review
        return result;
      } else
        throw Exception(CustomAPIError.missingBearerToken);
    } catch (e) {
      throw (e);
    }
  }

  Future<List<CollectDealTransactionModel>> getCollectDealHistories({
    DateTime? fromDate,
    DateTime? toDate,
    int? fromTotal,
    int? toTotal,
    int? page,
    int? pageSize,
  }) async {
    try {
      //get access token
      var accessToken =
          await SecureStorage.readValue(key: CustomKeys.accessToken);

      if (accessToken != null) {
        // Get dealer account Id
        var dealer =
            await AccountNetwork.getDealerInfo(bearerToken: accessToken);

        List<CollectDealTransactionModel> resData =
            (await CollectDealTransactionNetWork.getCollectDealHistories(
          bearerToken: accessToken,
          dealerAccountId: dealer.dealerInfoModel.id,
          fromDate: fromDate?.toIso8601String(),
          toDate: toDate?.toIso8601String(),
          fromTotal: fromTotal?.toString(),
          toTotal: toTotal?.toString(),
          page: page?.toString(),
          pageSize: pageSize?.toString(),
        ))
                .resData;
        //get info review
        return resData;
      } else
        throw Exception(CustomAPIError.missingBearerToken);
    } catch (e) {
      throw (e);
    }
  }

  Future<CDTransactionHistoryDetailModel> getCollectDealHistoryDetail({
    required String id,
  }) async {
    try {
      //get access token
      var accessToken =
          await SecureStorage.readValue(key: CustomKeys.accessToken);

      if (accessToken != null) {
        CDTransactionHistoryDetailModel resData =
            (await CollectDealTransactionNetWork.getCollectDealHistoryDetail(
          bearerToken: accessToken,
          id: id,
        ))
                .resData;
        //get info review
        return resData;
      } else
        throw Exception(CustomAPIError.missingBearerToken);
    } catch (e) {
      throw (e);
    }
  }
}
