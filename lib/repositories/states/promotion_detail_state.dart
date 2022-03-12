import 'package:dealer_app/repositories/models/get_promotion_detail_model.dart';
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

abstract class PromotionDetailState extends Equatable {
  final GetPromotionDetailModel model;

  PromotionDetailState(this.model);
}

class LoadingState extends PromotionDetailState {
  LoadingState({
    required GetPromotionDetailModel model,
  }) : super(model);

  @override
  List<Object?> get props => [model];
}

class LoadedState extends PromotionDetailState {
  LoadedState({
    required GetPromotionDetailModel model,
  }) : super(model);

  @override
  List<Object?> get props => [model];
}

class ErrorState extends PromotionDetailState {
  final String message;

  ErrorState({
    required GetPromotionDetailModel model,
    required this.message,
  }) : super(model);

  @override
  List<Object?> get props => [model, message];
}

class SuccessState extends PromotionDetailState {
  final String message;

  SuccessState({
    required GetPromotionDetailModel model,
    required this.message,
  }) : super(model);

  @override
  List<Object?> get props => [model, message];
}

class DeleteState extends PromotionDetailState {
  final String message;

  DeleteState({
    required GetPromotionDetailModel model,
    required this.message,
  }) : super(model);

  @override
  List<Object?> get props => [model, message];
}
