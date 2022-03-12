import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/repositories/events/promotion_list_event.dart';
import 'package:dealer_app/repositories/handlers/data_handler.dart';
import 'package:dealer_app/repositories/handlers/promotion_handler.dart';
import 'package:dealer_app/repositories/models/get_promotion_model.dart';
import 'package:dealer_app/repositories/states/promotion_list_state.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PromotionListBloc extends Bloc<PromotionListEvent, PromotionListState> {
  final _promotionHandler = getIt.get<IPromotionHandler>();
  final _dataHandler = getIt.get<IDataHandler>();

  PromotionListBloc() : super(NotLoadedState()) {
    add(EventInitData());
  }

  @override
  Stream<PromotionListState> mapEventToState(PromotionListEvent event) async* {
    if (event is EventInitData) {
      yield NotLoadedState();
      try {
        List<GetPromotionModel> promotionList =
            await _promotionHandler.getPromotions();
        yield LoadedState(
          promotionList: promotionList,
          filteredPromotionList:
              _getPromotionListFiltered(promotionList: promotionList, name: ''),
        );

        // Create new list
        List<GetPromotionModel> promotionListWithImage = [];
        for (var item in promotionList) {
          promotionListWithImage.add(GetPromotionModel(
            id: item.id,
            code: item.code,
            promotionName: item.promotionName,
            appliedScrapCategory: item.appliedScrapCategory,
            appliedScrapCategoryImageUrl: item.appliedScrapCategoryImageUrl,
            appliedAmount: item.appliedAmount,
            bonusAmount: item.bonusAmount,
            appliedFromTime: item.appliedFromTime,
            appliedToTime: item.appliedToTime,
            status: item.status,
          ));
        }
        promotionListWithImage = await _addImages(list: promotionListWithImage);
        yield LoadedState(
          promotionList: promotionListWithImage,
          filteredPromotionList: _getPromotionListFiltered(
              promotionList: promotionListWithImage, name: ''),
        );
      } catch (e) {
        print(e);
        yield ErrorState(errorMessage: 'Đã có lỗi xảy ra, vui lòng thử lại');
        //  if (e.toString().contains(CustomAPIError.missingBearerToken))
        // print(e);
      }
    }
    // if (event is EventLoadMoreCategories) {
    //   try {
    //     // Get new transactions
    //     List<GetPromotionModel> newList =
    //         await _promotionHandler.getPromotions();
    //     // If there is more transactions
    //     if (newList.isNotEmpty) {
    //       List<GetPromotionModel> promotionList =
    //           List.from((state as LoadedState).promotionList);
    //       promotionList.addAll(newList);

    //       yield (state as LoadedState).copyWith(
    //         promotionList: promotionList,
    //         filteredPromotionList: _getPromotionListFiltered(
    //             promotionList: promotionList,
    //             name: (state as LoadedState).searchName),
    //       );

    //       List<GetPromotionModel> promotionListWithImage = [];
    //       for (var item in promotionList) {
    //         promotionListWithImage.add(GetPromotionModel(
    //           id: item.id,
    //           code: item.code,
    //           promotionName: item.promotionName,
    //           appliedScrapCategory: item.appliedScrapCategory,
    //           appliedScrapCategoryImageUrl: item.appliedScrapCategoryImageUrl,
    //           appliedAmount: item.appliedAmount,
    //           bonusAmount: item.bonusAmount,
    //           appliedFromTime: item.appliedFromTime,
    //           appliedToTime: item.appliedToTime,
    //           status: item.status,
    //         ));
    //       }
    //       promotionListWithImage =
    //           await _addImages(list: promotionListWithImage);
    //       yield (state as LoadedState).copyWith(
    //         promotionList: promotionListWithImage,
    //         filteredPromotionList: _getPromotionListFiltered(
    //             promotionList: promotionListWithImage,
    //             name: (state as LoadedState).searchName),
    //       );
    //     }
    //   } catch (e) {
    //     yield ErrorState(errorMessage: 'Đã có lỗi xảy ra, vui lòng thử lại');
    //     //  if (e.toString().contains(CustomAPIError.missingBearerToken))
    //     // print(e);
    //   }
    // }
    if (event is EventChangeSearchName) {
      yield (state as LoadedState).copyWith(
        searchName: event.searchName,
        filteredPromotionList: _getPromotionListFiltered(
            promotionList: (state as LoadedState).promotionList,
            name: event.searchName),
      );
    }
  }

  Future<List<GetPromotionModel>> _addImages(
      {required List<GetPromotionModel> list}) async {
    for (var item in list) {
      if (item.appliedScrapCategoryImageUrl != CustomTexts.emptyString)
        item.image = await _dataHandler.getImageBytes(
            imageUrl: item.appliedScrapCategoryImageUrl);
      else
        item.image = null;
    }
    return list;
  }

  List<GetPromotionModel> _getPromotionListFiltered({
    required List<GetPromotionModel> promotionList,
    required String name,
  }) {
    if (name == CustomTexts.emptyString) return promotionList;
    // Check transactionList
    if (promotionList.isEmpty) return List.empty();
    // return filtered List
    List<GetPromotionModel> list = promotionList
        .where((element) =>
            element.promotionName.toLowerCase().contains(name.toLowerCase()))
        .toList();

    return list;
  }
}
