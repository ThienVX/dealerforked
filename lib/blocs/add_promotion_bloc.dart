import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/repositories/events/add_promotion_event.dart';
import 'package:dealer_app/repositories/handlers/promotion_handler.dart';
import 'package:dealer_app/repositories/handlers/scrap_category_handler.dart';
import 'package:dealer_app/repositories/models/request_models/post_promotion_request_model.dart';
import 'package:dealer_app/repositories/models/scrap_category_model.dart';
import 'package:dealer_app/repositories/states/add_promotion_state.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPromotionBloc extends Bloc<AddPromotionEvent, AddPromotionState> {
  final _promotionHandler = getIt.get<IPromotionHandler>();
  final _scrapCategoryHandler = getIt.get<IScrapCategoryHandler>();

  AddPromotionBloc()
      : super(
          LoadingState(
            promotionName: CustomTexts.emptyString,
            appliedAmount: 0,
            bonusAmount: 0,
            categories: [],
          ),
        ) {
    add(EventInitData());
  }

  @override
  Stream<AddPromotionState> mapEventToState(AddPromotionEvent event) async* {
    if (event is EventInitData) {
      try {
        List<ScrapCategoryModel> categories =
            await _scrapCategoryHandler.getScrapCategories();

        yield LoadedState(
          promotionName: CustomTexts.emptyString,
          appliedAmount: 0,
          bonusAmount: 0,
          categories: categories,
        );
      } catch (e) {
        print(e);
        yield ErrorState(
          message: 'Đã có lỗi xảy ra, vui lòng thử lại',
          promotionName: CustomTexts.emptyString,
          appliedAmount: 0,
          bonusAmount: 0,
          categories: [],
        );
        //  if (e.toString().contains(CustomAPIError.missingBearerToken))
        // print(e);
      }
    }
    if (event is EventChangePromotionName) {
      yield LoadedState(
        promotionName: event.promotionName,
        promotionScrapCategoryId: state.promotionScrapCategoryId,
        appliedAmount: state.appliedAmount,
        bonusAmount: state.bonusAmount,
        categories: state.categories,
        appliedFromTime: state.appliedFromTime,
        appliedToTime: state.appliedToTime,
      );
    }
    if (event is EventChangePromotionScrapCategoryId) {
      yield LoadedState(
        promotionName: state.promotionName,
        promotionScrapCategoryId: event.promotionScrapCategoryId,
        appliedAmount: state.appliedAmount,
        bonusAmount: state.bonusAmount,
        categories: state.categories,
        appliedFromTime: state.appliedFromTime,
        appliedToTime: state.appliedToTime,
      );
    }
    if (event is EventChangeAppliedAmount) {
      int? amount =
          int.tryParse(event.appliedAmount.replaceAll(RegExp(r'[^0-9]'), ''));

      yield LoadedState(
        promotionName: state.promotionName,
        promotionScrapCategoryId: state.promotionScrapCategoryId,
        appliedAmount: amount ?? state.appliedAmount,
        bonusAmount: state.bonusAmount,
        categories: state.categories,
        appliedFromTime: state.appliedFromTime,
        appliedToTime: state.appliedToTime,
      );
    }
    if (event is EventChangeBonusAmount) {
      int? amount =
          int.tryParse(event.bonusAmount.replaceAll(RegExp(r'[^0-9]'), ''));

      yield LoadedState(
        promotionName: state.promotionName,
        promotionScrapCategoryId: state.promotionScrapCategoryId,
        appliedAmount: state.appliedAmount,
        bonusAmount: amount ?? state.bonusAmount,
        categories: state.categories,
        appliedFromTime: state.appliedFromTime,
        appliedToTime: state.appliedToTime,
      );
    }
    if (event is EventChangeDate) {
      yield LoadedState(
        promotionName: state.promotionName,
        promotionScrapCategoryId: state.promotionScrapCategoryId,
        appliedAmount: state.appliedAmount,
        bonusAmount: state.bonusAmount,
        categories: state.categories,
        appliedFromTime: event.fromDate,
        appliedToTime: event.toDate,
      );
    }
    if (event is EventSubmitPromotion) {
      try {
        if (state.promotionScrapCategoryId != null ||
            state.appliedFromTime != null ||
            state.appliedToTime != null) {
          bool result = await _promotionHandler.createPromotion(
            model: PostPromotionRequestModel(
              promotionName: state.promotionName,
              promotionScrapCategoryId: state.promotionScrapCategoryId!,
              appliedAmount: state.appliedAmount,
              bonusAmount: state.bonusAmount,
              appliedFromTime: state.appliedFromTime!,
              appliedToTime: state.appliedToTime!,
            ),
          );
          if (result)
            yield SuccessState(
              message: 'Thêm ưu đãi thành công',
              promotionName: state.promotionName,
              promotionScrapCategoryId: state.promotionScrapCategoryId,
              appliedAmount: state.appliedAmount,
              bonusAmount: state.bonusAmount,
              categories: state.categories,
              appliedFromTime: state.appliedFromTime,
              appliedToTime: state.appliedToTime,
            );
          else
            yield ErrorState(
              message: 'Có lỗi xảy ra khi tạo ưu đãi',
              promotionName: state.promotionName,
              promotionScrapCategoryId: state.promotionScrapCategoryId,
              appliedAmount: state.appliedAmount,
              bonusAmount: state.bonusAmount,
              categories: state.categories,
              appliedFromTime: state.appliedFromTime,
              appliedToTime: state.appliedToTime,
            );
        } else {
          yield ErrorState(
            message: 'Có lỗi xảy ra khi tạo ưu đãi',
            promotionName: state.promotionName,
            promotionScrapCategoryId: state.promotionScrapCategoryId,
            appliedAmount: state.appliedAmount,
            bonusAmount: state.bonusAmount,
            categories: state.categories,
            appliedFromTime: state.appliedFromTime,
            appliedToTime: state.appliedToTime,
          );
        }
      } catch (e) {
        yield ErrorState(
          message: 'Có lỗi xảy ra khi tạo ưu đãi',
          promotionName: state.promotionName,
          promotionScrapCategoryId: state.promotionScrapCategoryId,
          appliedAmount: state.appliedAmount,
          bonusAmount: state.bonusAmount,
          categories: state.categories,
          appliedFromTime: state.appliedFromTime,
          appliedToTime: state.appliedToTime,
        );
      }
    }
  }
}
