import 'package:dealer_app/log/logger.dart';
import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/providers/services/transaction_service.dart';
import 'package:dealer_app/repositories/events/statistic_event.dart';
import 'package:dealer_app/repositories/states/statistic_state.dart';
import 'package:dealer_app/utils/common_function.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:dealer_app/utils/extension_methods.dart';

class StatisticBloc extends Bloc<StatisticEvent, StatisticState> {
  StatisticBloc({
    TransactionService? transactionService,
    required int dealerType,
    required String dealerId,
  }) : super(StatisticState(
          dealerType: dealerType,
          dealerId: dealerId,
        )) {
    _transactionService = transactionService ?? getIt.get<TransactionService>();
  }

  late final TransactionService _transactionService;

  @override
  Stream<StatisticState> mapEventToState(StatisticEvent event) async* {
    if (event is StatisticIntial) {
      try {
        if (state.dealerType == DealerType.manager) {
          yield state.copyWith(status: FormzStatus.submissionInProgress);
          var listDealer = await futureAppDuration(
            _transactionService.getBranches(),
          );
          var dataInit = await futureAppDuration(
            _transactionService.getStatistic(
                state.dealerId, state.fromDate, state.toDate),
          );
          yield state.copyWith(
            status: FormzStatus.submissionSuccess,
            listDealer: listDealer,
            statisticData: dataInit,
          );
        } else {
          add(StatisticGet());
        }
      } catch (e) {
        AppLog.error(e);
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    } else if (event is StatisticGet) {
      try {
        yield state.copyWith(status: FormzStatus.submissionInProgress);
        var data = await futureAppDuration(
          _transactionService.getStatistic(
              state.dealerId, state.fromDate, state.toDate),
        );

        yield state.copyWith(
          status: FormzStatus.submissionSuccess,
          statisticData: data,
        );
      } catch (e) {
        AppLog.error(e);
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    } else if (event is StatisticChanged) {
      yield state.copyWith(
        fromDate: event.fromDate.onlyDate(),
        toDate: event.toDate.onlyDate(),
      );
      add(StatisticGet());
    } else if (event is StatisticDealerChanged) {
      yield state.copyWith(
        dealerId: event.id,
      );
      add(StatisticGet());
    }
  }
}
