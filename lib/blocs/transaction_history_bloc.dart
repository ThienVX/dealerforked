import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/repositories/events/transaction_history_event.dart';
import 'package:dealer_app/repositories/handlers/collect_deal_transaction_handler.dart';
import 'package:dealer_app/repositories/handlers/data_handler.dart';
import 'package:dealer_app/repositories/models/collect_deal_transaction_model.dart';
import 'package:dealer_app/repositories/states/transaction_history_state.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionHistoryBloc
    extends Bloc<TransactionHistoryEvent, TransactionHistoryState> {
  final _collectDealTransactionHandler =
      getIt.get<ICollectDealTransactionHandler>();
  final _dataHandler = getIt.get<IDataHandler>();

  TransactionHistoryBloc() : super(TransactionHistoryState()) {
    add(EventInitData());
  }

  final _initPage = 1;
  final _pageSize = 10;
  int _currentPage = 1;

  @override
  Stream<TransactionHistoryState> mapEventToState(
      TransactionHistoryEvent event) async* {
    if (event is EventInitData) {
      yield state.copyWith(process: TransactionHistoryProcess.processing);
      try {
        _currentPage = 1;

        List<CollectDealTransactionModel> transactionList =
            await _collectDealTransactionHandler.getCollectDealHistories(
          page: _initPage,
          pageSize: _pageSize,
          fromDate: state.fromDate,
          toDate: state.toDate,
          fromTotal: state.fromTotal,
          toTotal: state.toTotal,
        );
        yield state.copyWith(
            transactionList: transactionList,
            filteredTransactionList: _getTransactionListPhoneFiltered(
              transactionList: transactionList,
              name: state.searchName,
            ));
        yield state.copyWith(process: TransactionHistoryProcess.processed);

        List<CollectDealTransactionModel> transactionListWithImage = [];
        for (var item in transactionList) {
          transactionListWithImage.add(new CollectDealTransactionModel(
            collectorName: item.collectorName,
            id: item.id,
            total: item.total,
            transactionDateTime: item.transactionDateTime,
            collectorImage: item.collectorImage,
          ));
        }
        transactionListWithImage =
            await _addImages(list: transactionListWithImage);

        yield state.copyWith(
            transactionList: transactionListWithImage,
            filteredTransactionList: _getTransactionListPhoneFiltered(
              transactionList: transactionListWithImage,
              name: state.searchName,
            ));
      } catch (e) {
        print(e);
        yield state.copyWith(process: TransactionHistoryProcess.error);
        //  if (e.toString().contains(CustomAPIError.missingBearerToken))
        // print(e);
      } finally {
        yield state.copyWith(process: TransactionHistoryProcess.neutral);
      }
    }
    if (event is EventLoadMoreTransactions) {
      yield state.copyWith(process: TransactionHistoryProcess.processing);
      try {
        // Clone list
        var list =
            List<CollectDealTransactionModel>.from(state.transactionList);
        // Get new transactions
        List<CollectDealTransactionModel> newList =
            await _collectDealTransactionHandler.getCollectDealHistories(
          page: _currentPage + 1,
          pageSize: _pageSize,
          fromDate: state.fromDate,
          toDate: state.toDate,
          fromTotal: state.fromTotal,
          toTotal: state.toTotal,
        );
        // If there is more transactions
        if (newList.isNotEmpty) {
          _currentPage += 1;
          list.addAll(newList);
          yield state.copyWith(
              transactionList: list,
              filteredTransactionList: _getTransactionListPhoneFiltered(
                transactionList: list,
                name: state.searchName,
              ));
        }
        yield state.copyWith(process: TransactionHistoryProcess.processed);

        List<CollectDealTransactionModel> transactionListWithImage = [];
        for (var item in list) {
          transactionListWithImage.add(new CollectDealTransactionModel(
            collectorName: item.collectorName,
            id: item.id,
            total: item.total,
            transactionDateTime: item.transactionDateTime,
            collectorImage: item.collectorImage,
          ));
        }
        transactionListWithImage =
            await _addImages(list: transactionListWithImage);

        yield state.copyWith(
            transactionList: transactionListWithImage,
            filteredTransactionList: _getTransactionListPhoneFiltered(
              transactionList: transactionListWithImage,
              name: state.searchName,
            ));
      } catch (e) {
        yield state.copyWith(process: TransactionHistoryProcess.processed);
        //  if (e.toString().contains(CustomAPIError.missingBearerToken))
        // print(e);
      } finally {
        yield state.copyWith(process: TransactionHistoryProcess.neutral);
      }
    }
    if (event is EventChangeTotalRange) {
      yield state.copyWith(
        fromTotal: event.startValue.toInt(),
        toTotal: event.endValue.toInt(),
      );
    }
    if (event is EventChangeDate) {
      yield state.copyWith(
        fromDate: event.fromDate,
        toDate: event.toDate,
      );
    }
    if (event is EventResetFilter) {
      yield state.resetFilter();
      add(EventInitData());
    }
    if (event is EventChangeSearchName) {
      yield state.copyWith(
          searchPhone: event.searchName,
          filteredTransactionList: _getTransactionListPhoneFiltered(
            transactionList: state.transactionList,
            name: event.searchName,
          ));
    }
  }

  List<CollectDealTransactionModel> _getTransactionListPhoneFiltered(
      {required List<CollectDealTransactionModel> transactionList,
      required String name}) {
    if (name == CustomTexts.emptyString) return transactionList;
    // Check transactionList
    if (transactionList.isEmpty) return List.empty();
    // return filtered List
    var list = transactionList
        .where((element) =>
            element.collectorName.toLowerCase().contains(name.toLowerCase()))
        .toList();
    return list;
  }

  Future<List<CollectDealTransactionModel>> _addImages(
      {required List<CollectDealTransactionModel> list}) async {
    for (var item in list) {
      if (item.collectorImage != CustomTexts.emptyString &&
          item.collectorImage != null)
        item.image =
            await _dataHandler.getImageBytes(imageUrl: item.collectorImage!);
      else
        item.image = null;
    }
    return list;
  }
}
