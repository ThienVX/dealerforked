import 'package:dealer_app/repositories/models/scrap_category_model.dart';
import 'package:equatable/equatable.dart';

abstract class AddPromotionState extends Equatable {
  final String promotionName;
  final String? promotionScrapCategoryId;
  final int appliedAmount;
  final int bonusAmount;
  final DateTime? appliedFromTime;
  final DateTime? appliedToTime;

  final List<ScrapCategoryModel> categories;

  AddPromotionState(
    this.promotionName,
    this.promotionScrapCategoryId,
    this.appliedAmount,
    this.bonusAmount,
    this.appliedFromTime,
    this.appliedToTime,
    this.categories,
  );
}

class LoadingState extends AddPromotionState {
  LoadingState({
    required String promotionName,
    String? promotionScrapCategoryId,
    required int appliedAmount,
    required int bonusAmount,
    DateTime? appliedFromTime,
    DateTime? appliedToTime,
    required List<ScrapCategoryModel> categories,
  }) : super(
          promotionName,
          promotionScrapCategoryId,
          appliedAmount,
          bonusAmount,
          appliedFromTime,
          appliedToTime,
          categories,
        );

  @override
  List<Object?> get props => [
        promotionName,
        promotionScrapCategoryId,
        appliedAmount,
        bonusAmount,
        appliedFromTime,
        appliedToTime,
        categories,
      ];
}

class LoadedState extends AddPromotionState {
  LoadedState({
    required String promotionName,
    String? promotionScrapCategoryId,
    required int appliedAmount,
    required int bonusAmount,
    DateTime? appliedFromTime,
    DateTime? appliedToTime,
    required List<ScrapCategoryModel> categories,
  }) : super(
          promotionName,
          promotionScrapCategoryId,
          appliedAmount,
          bonusAmount,
          appliedFromTime,
          appliedToTime,
          categories,
        );

  @override
  List<Object?> get props => [
        promotionName,
        promotionScrapCategoryId,
        appliedAmount,
        bonusAmount,
        appliedFromTime,
        appliedToTime,
        categories,
      ];
}

class ErrorState extends AddPromotionState {
  final String message;

  ErrorState(
      {required String promotionName,
      String? promotionScrapCategoryId,
      required int appliedAmount,
      required int bonusAmount,
      DateTime? appliedFromTime,
      DateTime? appliedToTime,
      required List<ScrapCategoryModel> categories,
      required this.message})
      : super(
          promotionName,
          promotionScrapCategoryId,
          appliedAmount,
          bonusAmount,
          appliedFromTime,
          appliedToTime,
          categories,
        );

  @override
  List<Object?> get props => [
        promotionName,
        promotionScrapCategoryId,
        appliedAmount,
        bonusAmount,
        appliedFromTime,
        appliedToTime,
        categories,
      ];
}

class SuccessState extends AddPromotionState {
  final String message;

  SuccessState(
      {required String promotionName,
      String? promotionScrapCategoryId,
      required int appliedAmount,
      required int bonusAmount,
      DateTime? appliedFromTime,
      DateTime? appliedToTime,
      required List<ScrapCategoryModel> categories,
      required this.message})
      : super(
          promotionName,
          promotionScrapCategoryId,
          appliedAmount,
          bonusAmount,
          appliedFromTime,
          appliedToTime,
          categories,
        );

  @override
  List<Object?> get props => [
        promotionName,
        promotionScrapCategoryId,
        appliedAmount,
        bonusAmount,
        appliedFromTime,
        appliedToTime,
        categories,
      ];
}
