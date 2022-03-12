import 'package:equatable/equatable.dart';

abstract class AddPromotionEvent extends Equatable {}

class EventInitData extends AddPromotionEvent {
  @override
  List<Object?> get props => [];
}

class EventChangePromotionName extends AddPromotionEvent {
  final String promotionName;

  EventChangePromotionName(this.promotionName);

  @override
  List<Object?> get props => [promotionName];
}

class EventChangePromotionScrapCategoryId extends AddPromotionEvent {
  final String promotionScrapCategoryId;

  EventChangePromotionScrapCategoryId(this.promotionScrapCategoryId);

  @override
  List<Object?> get props => [promotionScrapCategoryId];
}

class EventChangeAppliedAmount extends AddPromotionEvent {
  final String appliedAmount;

  EventChangeAppliedAmount(this.appliedAmount);

  @override
  List<Object?> get props => [appliedAmount];
}

class EventChangeBonusAmount extends AddPromotionEvent {
  final String bonusAmount;

  EventChangeBonusAmount(this.bonusAmount);

  @override
  List<Object?> get props => [bonusAmount];
}

class EventChangeDate extends AddPromotionEvent {
  final DateTime fromDate;
  final DateTime toDate;

  EventChangeDate({
    required this.fromDate,
    required this.toDate,
  });

  @override
  List<Object?> get props => [fromDate];
}

class EventSubmitPromotion extends AddPromotionEvent {
  @override
  List<Object?> get props => [];
}
