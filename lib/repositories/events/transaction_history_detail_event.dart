import 'package:equatable/equatable.dart';

abstract class TransactionHistoryDetailEvent extends Equatable {}

class EventInitData extends TransactionHistoryDetailEvent {
  @override
  List<Object?> get props => [];
}
