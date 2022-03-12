import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/repositories/events/promotion_detail_event.dart';
import 'package:dealer_app/repositories/handlers/promotion_handler.dart';
import 'package:dealer_app/repositories/models/get_promotion_detail_model.dart';
import 'package:dealer_app/repositories/states/promotion_detail_state.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PromotionDetailBloc
    extends Bloc<PromotionDetailEvent, PromotionDetailState> {
  final _promotionHandler = getIt.get<IPromotionHandler>();

  PromotionDetailBloc({required this.promotionId})
      : super(LoadingState(
          model: new GetPromotionDetailModel(
            code: CustomTexts.emptyString,
            promotionName: CustomTexts.emptyString,
            appliedScrapCategory: CustomTexts.emptyString,
            appliedAmount: 0,
            bonusAmount: 0,
            appliedFromTime: CustomTexts.emptyString,
            appliedToTime: CustomTexts.emptyString,
          ),
        )) {
    add(EventInitData());
  }

  final String promotionId;

  @override
  Stream<PromotionDetailState> mapEventToState(
      PromotionDetailEvent event) async* {
    if (event is EventInitData) {
      try {
        GetPromotionDetailModel promotionDetailModel = await _promotionHandler
            .getPromotionDetail(promotionId: promotionId);

        yield LoadedState(
          model: promotionDetailModel,
        );
      } catch (e) {
        print(e);
        yield ErrorState(
          message: 'Đã có lỗi xảy ra, vui lòng thử lại',
          model: new GetPromotionDetailModel(
            code: CustomTexts.emptyString,
            promotionName: CustomTexts.emptyString,
            appliedScrapCategory: CustomTexts.emptyString,
            appliedAmount: 0,
            bonusAmount: 0,
            appliedFromTime: CustomTexts.emptyString,
            appliedToTime: CustomTexts.emptyString,
          ),
        );
        //  if (e.toString().contains(CustomAPIError.missingBearerToken))
        // print(e);
      }
    }
    if (event is EventTapDeleteButton) {
      yield DeleteState(
        message: 'Kết thúc ưu đãi ${state.model.promotionName} ?',
        model: new GetPromotionDetailModel(
          code: state.model.code,
          promotionName: state.model.promotionName,
          appliedScrapCategory: state.model.appliedScrapCategory,
          appliedAmount: state.model.appliedAmount,
          bonusAmount: state.model.bonusAmount,
          appliedFromTime: state.model.appliedFromTime,
          appliedToTime: state.model.appliedToTime,
        ),
      );
    }
    if (event is EventDeletePromotion) {
      bool result = await _promotionHandler.deletePromotion(id: promotionId);
      if (result)
        yield SuccessState(
          message:
              'Kết thúc ưu đãi ${state.model.promotionName} thành công',
          model: new GetPromotionDetailModel(
            code: CustomTexts.emptyString,
            promotionName: CustomTexts.emptyString,
            appliedScrapCategory: CustomTexts.emptyString,
            appliedAmount: 0,
            bonusAmount: 0,
            appliedFromTime: CustomTexts.emptyString,
            appliedToTime: CustomTexts.emptyString,
          ),
        );
    }
  }
}
