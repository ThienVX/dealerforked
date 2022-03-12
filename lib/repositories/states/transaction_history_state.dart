import 'package:dealer_app/repositories/models/collect_deal_transaction_model.dart';
import 'package:dealer_app/utils/param_util.dart';

enum TransactionHistoryProcess {
  neutral,
  processing,
  processed,
  error,
  valid,
  invalid,
}

class TransactionHistoryState {
  TransactionHistoryProcess process;
  List<CollectDealTransactionModel> transactionList;
  List<CollectDealTransactionModel> filteredTransactionList;
  String searchName;
  DateTime? fromDate, toDate;
  int fromTotal, toTotal;

  int totalMin = 0;
  int totalMax = 10000000;
  int get getDivision => totalMax ~/ 250000;

  TransactionHistoryState({
    TransactionHistoryProcess? process,
    List<CollectDealTransactionModel>? transactionList,
    List<CollectDealTransactionModel>? filteredTransactionList,
    String? searchPhone,
    DateTime? fromDate,
    DateTime? toDate,
    int? fromTotal,
    int? toTotal,
  })  : process = process ?? TransactionHistoryProcess.neutral,
        transactionList = transactionList ?? [],
        filteredTransactionList = filteredTransactionList ?? [],
        searchName = searchPhone ?? CustomTexts.emptyString,
        fromDate = fromDate,
        toDate = toDate,
        fromTotal = fromTotal ?? 0,
        toTotal = toTotal ?? 10000000;

  TransactionHistoryState copyWith({
    TransactionHistoryProcess? process,
    List<CollectDealTransactionModel>? transactionList,
    List<CollectDealTransactionModel>? filteredTransactionList,
    String? searchPhone,
    DateTime? fromDate,
    DateTime? toDate,
    int? fromTotal,
    int? toTotal,
  }) {
    return TransactionHistoryState(
      process: process ?? this.process,
      transactionList: transactionList ?? this.transactionList,
      filteredTransactionList:
          filteredTransactionList ?? this.filteredTransactionList,
      searchPhone: searchPhone ?? this.searchName,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      fromTotal: fromTotal ?? this.fromTotal,
      toTotal: toTotal ?? this.toTotal,
    );
  }

  TransactionHistoryState resetFilter() {
    return TransactionHistoryState(
      process: this.process,
      transactionList: this.transactionList,
      filteredTransactionList: this.filteredTransactionList,
      searchPhone: this.searchName,
      fromDate: null,
      toDate: null,
      fromTotal: null,
      toTotal: null,
    );
  }
}
