import 'package:equatable/equatable.dart';

abstract class PromotionListEvent extends Equatable {}

class EventInitData extends PromotionListEvent {
  @override
  List<Object?> get props => [];
}

class EventLoadMoreCategories extends PromotionListEvent {
  @override
  List<Object?> get props => [];
}

class EventChangeSearchName extends PromotionListEvent {
  final String searchName;

  EventChangeSearchName({required this.searchName});

  @override
  List<Object> get props => [searchName];
}
