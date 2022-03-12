import 'package:dealer_app/constants/common_constants.dart';
import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/providers/network/transaction_network.dart';
import 'package:dealer_app/repositories/models/request_models/create_comlaint_request_model.dart';
import 'package:dealer_app/repositories/states/statistic_state.dart';
import 'package:http/http.dart';

abstract class TransactionService {
  Future<StatisticData> getStatistic(
      String dealerId, DateTime fromDate, DateTime toDate);
  Future<List<DealerInfo>> getBranches();
  Future<bool> feedbackAdmin(String requetsId, String sellingFeedback);
}

class TransactionServiceImpl implements TransactionService {
  TransactionServiceImpl({
    TransactionNetwork? transactionNetwork,
  }) {
    _transactionNetwork = transactionNetwork ?? getIt.get<TransactionNetwork>();
  }

  late final TransactionNetwork _transactionNetwork;

  @override
  Future<StatisticData> getStatistic(
      String dealerId, DateTime fromDate, DateTime toDate) async {
    StatisticData reuslt = StatisticData();
    Client client = Client();
    var responseModel = await _transactionNetwork
        .getStatistic(
          dealerId,
          fromDate,
          toDate,
          client,
        )
        .whenComplete(
          () => client.close(),
        );
    var d = responseModel.resData;
    if (d != null) {
      reuslt = StatisticData(
        totalCollecting: d.totalCollecting,
        totalFee: d.totalFee,
        bonusAmount: d.bonusAmount,
        numOfCompletedTrans: d.numOfCompletedTrans,
      );
    }
    return reuslt;
  }

  @override
  Future<List<DealerInfo>> getBranches() async {
    List<DealerInfo> result = [];
    Client client = Client();
    var responseModel = await _transactionNetwork
        .getBranches(
          client,
        )
        .whenComplete(
          () => client.close(),
        );
    var d = responseModel.resData;
    if (d != null) {
      result = d.map((e) {
        return DealerInfo(id: e.dealerAccountId, name: e.dealerName);
      }).toList();
    }
    return result;
  }

  @override
  Future<bool> feedbackAdmin(String requetsId, String complaint) async {
    Client client = Client();
    var result = await _transactionNetwork
        .createComplaint(
            CreateComplaintequestModel(
              collectDealTransactionId: requetsId,
              complaintContent: complaint,
            ),
            client)
        .whenComplete(() => client.close());

    return result.isSuccess && result.statusCode == NetworkConstants.ok200;
  }
}
