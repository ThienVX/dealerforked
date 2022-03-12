import 'package:dealer_app/utils/param_util.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:dealer_app/utils/extension_methods.dart';

class StatisticState extends Equatable {
  StatisticState({
    this.dealerId = Symbols.empty,
    List<DealerInfo>? listDealer,
    required this.dealerType,
    DateTime? fromDate,
    DateTime? toDate,
    this.statisticData = const StatisticData(),
    this.status = FormzStatus.pure,
  }) {
    this.listDealer = listDealer ?? [];
    this.fromDate = fromDate ?? DateTime.now().onlyDate();
    this.toDate = toDate ?? DateTime.now().onlyDate();
  }

  final String dealerId;
  late final List<DealerInfo> listDealer;
  final int dealerType;
  late final DateTime fromDate;
  late final DateTime toDate;
  final StatisticData statisticData;
  final FormzStatus status;

  StatisticState copyWith({
    String? dealerId,
    List<DealerInfo>? listDealer,
    int? dealerType,
    DateTime? fromDate,
    DateTime? toDate,
    StatisticData? statisticData,
    FormzStatus? status,
  }) {
    return StatisticState(
      dealerId: dealerId ?? this.dealerId,
      listDealer: listDealer ?? this.listDealer,
      dealerType: dealerType ?? this.dealerType,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      statisticData: statisticData ?? this.statisticData,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        dealerId,
        listDealer,
        dealerType,
        fromDate,
        toDate,
        statisticData,
        status,
      ];
}

class StatisticData extends Equatable {
  final int totalCollecting;
  final int totalFee;
  final int bonusAmount;
  final int numOfCompletedTrans;

  const StatisticData({
    this.totalCollecting = 0,
    this.totalFee = 0,
    this.bonusAmount = 0,
    this.numOfCompletedTrans = 0,
  });

  StatisticData copyWith({
    int? totalCollecting,
    int? totalFee,
    int? bonusAmount,
    int? numOfCompletedTrans,
  }) {
    return StatisticData(
      totalCollecting: totalCollecting ?? this.totalCollecting,
      totalFee: totalFee ?? this.totalFee,
      bonusAmount: bonusAmount ?? this.bonusAmount,
      numOfCompletedTrans: numOfCompletedTrans ?? this.numOfCompletedTrans,
    );
  }

  @override
  List<int> get props => [
        totalCollecting,
        totalFee,
        bonusAmount,
        numOfCompletedTrans,
      ];
}

class DealerInfo extends Equatable {
  final String id;
  final String name;

  const DealerInfo({
    required this.id,
    required this.name,
  });

  @override
  List<String> get props => [
        id,
        name,
      ];
}
