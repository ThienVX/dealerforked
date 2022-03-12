import 'package:dealer_app/repositories/models/collect_deal_transaction_detail_model.dart';
import 'package:equatable/equatable.dart';

abstract class CreateTransactionEvent extends Equatable {}

class EventPhoneNumberChanged extends CreateTransactionEvent {
  final String collectorPhone;

  EventPhoneNumberChanged({required this.collectorPhone});

  @override
  List<String> get props => [collectorPhone];
}

class EventCollectorIdChanged extends CreateTransactionEvent {
  final String collectorId;

  EventCollectorIdChanged({required this.collectorId});

  @override
  List<String> get props => [collectorId];
}

class EventCalculatedByUnitPriceChanged extends CreateTransactionEvent {
  final bool isCalculatedByUnitPrice;

  EventCalculatedByUnitPriceChanged({required this.isCalculatedByUnitPrice});

  @override
  List<bool> get props => [isCalculatedByUnitPrice];
}

class EventDealerCategoryChanged extends CreateTransactionEvent {
  final String dealerCategoryId;

  EventDealerCategoryChanged({required this.dealerCategoryId});

  @override
  List<String> get props => [dealerCategoryId];
}

class EventDealerCategoryUnitChanged extends CreateTransactionEvent {
  final String dealerCategoryDetailId;

  EventDealerCategoryUnitChanged({required this.dealerCategoryDetailId});

  @override
  List<String> get props => [dealerCategoryDetailId];
}

class EventItemTotalChanged extends CreateTransactionEvent {
  final String total;

  EventItemTotalChanged({required this.total});

  @override
  List<String> get props => [total];
}

class EventQuantityChanged extends CreateTransactionEvent {
  final String quantity;

  EventQuantityChanged({required this.quantity});

  @override
  List<String> get props => [quantity];
}

class EventUnitPriceChanged extends CreateTransactionEvent {
  final String unitPrice;

  EventUnitPriceChanged({required this.unitPrice});

  @override
  List<String> get props => [unitPrice];
}

class EventAddNewItem extends CreateTransactionEvent {
  @override
  List<Object?> get props => [];
}

class EventUpdateItem extends CreateTransactionEvent {
  @override
  List<Object?> get props => [];
}

class EventSubmitNewTransaction extends CreateTransactionEvent {
  @override
  List<Object?> get props => [];
}

class EventShowItemDialog extends CreateTransactionEvent {
  final int? key;
  final CollectDealTransactionDetailModel? detail;

  EventShowItemDialog({this.detail, this.key});

  @override
  List<Object?> get props => [key, detail];
}

class EventInitValues extends CreateTransactionEvent {
  @override
  List<Object?> get props => [];
}

class EventReloadValues extends CreateTransactionEvent {
  @override
  List<Object?> get props => [];
}

class EventDissmissPopup extends CreateTransactionEvent {
  @override
  List<Object?> get props => [];
}

class EventDeleteItem extends CreateTransactionEvent {
  final int key;

  EventDeleteItem({required this.key});

  @override
  List<Object> get props => [key];
}
