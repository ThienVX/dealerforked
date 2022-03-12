import 'package:dealer_app/repositories/models/collect_deal_transaction_history_detail_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

enum TransactionHistoryDetailProcess {
  neutral,
  processing,
  processed,
  error,
  valid,
  invalid,
}

abstract class TransactionHistoryDetailState extends Equatable {}

class NotLoadedState extends TransactionHistoryDetailState {
  @override
  List<Object?> get props => [];
}

class LoadedState extends TransactionHistoryDetailState {
  final String id;
  final CDTransactionHistoryDetailModel model;
  final int grandTotal;
  final ImageProvider? image;

  LoadedState({
    required this.id,
    required this.model,
    required this.grandTotal,
    required this.image,
  });

  @override
  List<Object?> get props => [
        model,
        grandTotal,
        image,
      ];
}
