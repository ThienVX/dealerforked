import 'package:dealer_app/providers/network/dealer_info_network.dart';
import 'package:dealer_app/repositories/models/get_branches_model.dart';
import 'package:dealer_app/repositories/models/get_dealer_info_model.dart';
import 'package:dealer_app/repositories/models/response_models/get_branch_detail_response_model.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:dealer_app/utils/secure_storage.dart';

abstract class IDealerInfoHandler {
  Future<GetDealerInfoModel> getDealerInfo();
  Future<List<GetBranchesModel>> getBranches();
  Future<GetBranchDetailModel> getBranchDetail({required String id});
}

class DealerInfoHandler implements IDealerInfoHandler {
  Future<GetDealerInfoModel> getDealerInfo() async {
    try {
      //get access token
      var accessToken =
          await SecureStorage.readValue(key: CustomKeys.accessToken);
      if (accessToken != null) {
        GetDealerInfoModel getDealerInfoModel =
            (await DealerInfoNetwork.getDealerInfo(bearerToken: accessToken))
                .resData;
        return getDealerInfoModel;
      } else
        throw Exception(CustomAPIError.missingBearerToken);
    } catch (e) {
      throw (e);
    }
  }

  Future<List<GetBranchesModel>> getBranches() async {
    try {
      //get access token
      var accessToken =
          await SecureStorage.readValue(key: CustomKeys.accessToken);
      if (accessToken != null) {
        List<GetBranchesModel> branches =
            (await DealerInfoNetwork.getBranches(bearerToken: accessToken))
                .resData;
        return branches;
      } else
        throw Exception(CustomAPIError.missingBearerToken);
    } catch (e) {
      throw (e);
    }
  }

  Future<GetBranchDetailModel> getBranchDetail({required String id}) async {
    try {
      //get access token
      var accessToken =
          await SecureStorage.readValue(key: CustomKeys.accessToken);
      if (accessToken != null) {
        GetBranchDetailModel branch = (await DealerInfoNetwork.getBranchDetail(
          bearerToken: accessToken,
          id: id,
        ))
            .resData;
        return branch;
      } else
        throw Exception(CustomAPIError.missingBearerToken);
    } catch (e) {
      throw (e);
    }
  }
}
