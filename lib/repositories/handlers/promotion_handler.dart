import 'package:dealer_app/providers/network/promotion_network.dart';
import 'package:dealer_app/repositories/models/get_promotion_detail_model.dart';
import 'package:dealer_app/repositories/models/get_promotion_model.dart';
import 'package:dealer_app/repositories/models/request_models/post_promotion_request_model.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:dealer_app/utils/secure_storage.dart';

abstract class IPromotionHandler {
  Future<bool> createPromotion({required PostPromotionRequestModel model});
  Future<List<GetPromotionModel>> getPromotions();
  Future<GetPromotionDetailModel> getPromotionDetail(
      {required String promotionId});
  Future<bool> deletePromotion({required String id});
}

class PromotionHandler implements IPromotionHandler {
  Future<bool> createPromotion(
      {required PostPromotionRequestModel model}) async {
    try {
      //get access token
      var accessToken =
          await SecureStorage.readValue(key: CustomKeys.accessToken);
      if (accessToken != null) {
        var result = await PromotionNetwork.postPromotion(
          bearerToken: accessToken,
          body: postPromotionRequestModelToJson(model),
        );
        //get info review
        return result;
      } else
        throw Exception(CustomAPIError.missingBearerToken);
    } catch (e) {
      throw (e);
    }
  }

  Future<List<GetPromotionModel>> getPromotions() async {
    try {
      //get access token
      var accessToken =
          await SecureStorage.readValue(key: CustomKeys.accessToken);
      if (accessToken != null) {
        //get promotions
        var promotions =
            (await PromotionNetwork.getPromotion(bearerToken: accessToken))
                .resData;

        return promotions;
      } else
        throw Exception(CustomAPIError.missingBearerToken);
    } catch (e) {
      throw (e);
    }
  }

  @override
  Future<GetPromotionDetailModel> getPromotionDetail(
      {required String promotionId}) async {
    try {
      //get access token
      var accessToken =
          await SecureStorage.readValue(key: CustomKeys.accessToken);
      if (accessToken != null) {
        //get promotion detail
        var promotionDetail = (await PromotionNetwork.getPromotionDetail(
          bearerToken: accessToken,
          id: promotionId,
        ))
            .resData;

        return promotionDetail;
      } else
        throw Exception(CustomAPIError.missingBearerToken);
    } catch (e) {
      throw (e);
    }
  }

  Future<bool> deletePromotion({required String id}) async {
    try {
      //get access token
      var accessToken =
          await SecureStorage.readValue(key: CustomKeys.accessToken);
      if (accessToken != null) {
        var result = (await PromotionNetwork.putPromotion(
          bearerToken: accessToken,
          id: id,
        ));

        //get scrap categories
        return result['isSuccess'];
      } else
        throw Exception(CustomAPIError.missingBearerToken);
    } catch (e) {
      throw (e);
    }
  }
}
