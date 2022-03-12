import 'package:dealer_app/repositories/models/response_models/get_branch_detail_response_model.dart';
import 'package:dealer_app/repositories/models/response_models/get_branches_response_model.dart';
import 'package:dealer_app/repositories/models/response_models/get_dealer_info_response_model.dart';
import 'package:dealer_app/utils/env_util.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:http/http.dart' as http;

class DealerInfoNetwork {
  static Future<GetDealerInfoResponseModel> getDealerInfo(
      {required String bearerToken}) async {
    //add headers
    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
    };
    final uri = Uri.http(EnvAppApiSettingValue.apiUrl,
        CustomApiUrl.apiUrlGetDealerInfoFromDealerInformation);

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return getDealerInfoResponseModelFromJson(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(CustomAPIError.fetchDealerInfoFailedException);
    }
  }

  static Future<GetBranchesResponseModel> getBranches(
      {required String bearerToken}) async {
    //add headers
    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
    };
    final uri = Uri.http(EnvAppApiSettingValue.apiUrl,
        CustomApiUrl.apiUrlGetBranchesFromDealerInformation);

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return getBranchesResponseModelFromJson(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(CustomAPIError.fetchBranchesFailedException);
    }
  }

  static Future<GetBranchDetailResponseModel> getBranchDetail({
    required String bearerToken,
    required String id,
  }) async {
    //add headers
    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
    };
    Map<String, dynamic> params = {
      'id': id,
    };

    final uri = Uri.http(EnvAppApiSettingValue.apiUrl,
        CustomApiUrl.apiUrlGetBranchDetailFromDealerInformation, params);

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return getBranchDetailResponseModelFromJson(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(CustomAPIError.fetchBranchDetailFailedException);
    }
  }
}
