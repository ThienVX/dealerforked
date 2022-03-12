import 'package:equatable/equatable.dart';

abstract class TransactionHistoryEvent extends Equatable {}

class EventInitData extends TransactionHistoryEvent {
  @override
  List<Object?> get props => [];
}

class EventLoadMoreTransactions extends TransactionHistoryEvent {
  @override
  List<Object?> get props => [];
}

class EventChangeSearchName extends TransactionHistoryEvent {
  final String searchName;

  EventChangeSearchName({required this.searchName});

  @override
  List<Object> get props => [searchName];
}

class EventChangeDate extends TransactionHistoryEvent {
  final DateTime fromDate;
  final DateTime toDate;

  EventChangeDate({required this.fromDate, required this.toDate});

  @override
  List<Object> get props => [fromDate, toDate];
}

class EventChangeTotalRange extends TransactionHistoryEvent {
  final double startValue;
  final double endValue;

  EventChangeTotalRange({required this.startValue, required this.endValue});

  @override
  List<Object> get props => [startValue, endValue];
}

class EventResetFilter extends TransactionHistoryEvent {
  @override
  List<Object?> get props => [];
}
