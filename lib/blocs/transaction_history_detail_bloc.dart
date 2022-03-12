import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/repositories/events/transaction_history_detail_event.dart';
import 'package:dealer_app/repositories/handlers/collect_deal_transaction_handler.dart';
import 'package:dealer_app/repositories/handlers/data_handler.dart';
import 'package:dealer_app/repositories/models/collect_deal_transaction_history_detail_model.dart';
import 'package:dealer_app/repositories/states/transaction_history_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionHistoryDetailBloc
    extends Bloc<TransactionHistoryDetailEvent, TransactionHistoryDetailState> {
  final _collectDealTransactionHandler =
      getIt.get<ICollectDealTransactionHandler>();
  final _dataHandler = getIt.get<IDataHandler>();

  TransactionHistoryDetailBloc({required this.id}) : super(NotLoadedState()) {
    add(EventInitData());
  }

  final String id;

  @override
  Stream<TransactionHistoryDetailState> mapEventToState(
      TransactionHistoryDetailEvent event) async* {
    if (event is EventInitData) {
      yield NotLoadedState();
      var grandTotal;
      try {
        CDTransactionHistoryDetailModel model =
            await _collectDealTransactionHandler.getCollectDealHistoryDetail(
                id: id);
        grandTotal = model.total + model.totalBonus;

        var image;
        if (model.profileURL != null && model.profileURL.isNotEmpty) {
          image = await _dataHandler.getImageBytes(imageUrl: model.profileURL);
        }

        yield LoadedState(
            id: id, model: model, grandTotal: grandTotal, image: image);
      } catch (e) {
        //  if (e.toString().contains(CustomAPIError.missingBearerToken))
        print(e);
      }
    }
  }
}
