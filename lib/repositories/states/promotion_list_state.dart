import 'package:dealer_app/repositories/models/get_promotion_model.dart';
import 'package:equatable/equatable.dart';

enum PromotionStatus {
  FUTURE,
  CURRENT,
  PAST,
}

extension PromotionStatusExtension on PromotionStatus {
  int get statusInt {
    switch (this) {
      case PromotionStatus.FUTURE:
        return 3;
      case PromotionStatus.CURRENT:
        return 1;
      case PromotionStatus.PAST:
        return 2;
      default:
        return 0;
    }
  }
}

abstract class PromotionListState extends Equatable {}

class NotLoadedState extends PromotionListState {
  @override
  List<Object?> get props => [];
}

class LoadedState extends PromotionListState {
  final List<GetPromotionModel> promotionList;
  final List<GetPromotionModel> filteredPromotionList;
  final String searchName;

  LoadedState({
    required this.promotionList,
    required this.filteredPromotionList,
    this.searchName = '',
  });

  LoadedState copyWith({
    List<GetPromotionModel>? promotionList,
    List<GetPromotionModel>? filteredPromotionList,
    String? searchName,
  }) {
    return LoadedState(
      promotionList: promotionList ?? this.promotionList,
      filteredPromotionList:
          filteredPromotionList ?? this.filteredPromotionList,
      searchName: searchName ?? this.searchName,
    );
  }

  @override
  List<Object> get props => [promotionList, filteredPromotionList, searchName];
}

class ErrorState extends PromotionListState {
  final String errorMessage;

  ErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
