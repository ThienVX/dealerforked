import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/repositories/events/create_transaction_event.dart';
import 'package:dealer_app/repositories/handlers/collect_deal_transaction_handler.dart';
import 'package:dealer_app/repositories/handlers/data_handler.dart';
import 'package:dealer_app/repositories/handlers/promotion_handler.dart';
import 'package:dealer_app/repositories/models/collect_deal_transaction_detail_model.dart';
import 'package:dealer_app/repositories/models/collector_phone_model.dart';
import 'package:dealer_app/repositories/models/get_promotion_model.dart';
import 'package:dealer_app/repositories/models/info_review_model.dart';
import 'package:dealer_app/repositories/models/request_models/collect_deal_transaction_request_model.dart';
import 'package:dealer_app/repositories/models/scrap_category_model.dart';
import 'package:dealer_app/repositories/models/scrap_category_unit_model.dart';
import 'package:dealer_app/repositories/states/create_transaction_state.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateTransactionBloc
    extends Bloc<CreateTransactionEvent, CreateTransactionState> {
  var dataHandler = getIt.get<IDataHandler>();
  var promotionHandler = getIt.get<IPromotionHandler>();
  var collectDealTransactionHandler =
      getIt.get<ICollectDealTransactionHandler>();

  CreateTransactionBloc({required CreateTransactionState initialState})
      : super(initialState) {
    add(EventInitValues());
  }

  late List<GetPromotionModel> promotions;

  @override
  Stream<CreateTransactionState> mapEventToState(
      CreateTransactionEvent event) async* {
    if (event is EventInitValues) {
      //get categories
      yield state.copyWith(process: Process.processing);
      try {
        var collectorPhoneList = await dataHandler.getCollectorPhoneList();
        var scrapCategories = await dataHandler.getScrapCategoryList();
        if (scrapCategories != null) {
          Map<String, String> scrapCategoryMap = {};
          scrapCategories.forEach((element) {
            scrapCategoryMap.putIfAbsent(element.id, () => element.name);
          });
          yield state.copyWith(
            scrapCategories: scrapCategories,
            collectorPhoneList: collectorPhoneList,
            scrapCategoryMap: scrapCategoryMap,
            itemDealerCategoryId: CustomVar.unnamedScrapCategory.id,
          );
        }
        yield state.copyWith(process: Process.processed);
      } catch (e) {
        yield state.copyWith(process: Process.processed);
        yield state.copyWith(process: Process.error);
      } finally {
        yield state.copyWith(process: Process.neutral);
      }
    } else if (event is EventPhoneNumberChanged) {
      yield state.copyWith(
        collectorPhone: event.collectorPhone,
        isQRScanned: false,
      );
      // Check if phone is valid
      if (state.isPhoneValid) {
        yield state.copyWith(process: Process.processing);
        try {
          CollectorPhoneModel collectorModel = state.collectorPhoneList
              .firstWhere((element) => element.phone == event.collectorPhone);
          // Get collector name + id
          InfoReviewModel? collectorInfo = await collectDealTransactionHandler
              .getInfoReview(collectorId: collectorModel.id);
          // Check if collectorInfo is null
          if (collectorInfo != null) {
            yield state.copyWith(
              collectorId: collectorInfo.collectorId,
              collectorName: collectorInfo.collectorName,
              transactionFeePercent: collectorInfo.transactionFeePercent,
              isCollectorPhoneExist: true,
            );
          } else
            yield state.copyWith(isCollectorPhoneExist: false);
          //Done processing
          yield state.copyWith(process: Process.processed);
        } on StateError {
          yield state.copyWith(isCollectorPhoneExist: false);
          yield state.copyWith(process: Process.processed);
        } catch (e) {
          yield state.copyWith(process: Process.processed);
          yield state.copyWith(process: Process.error);
        } finally {
          yield state.copyWith(process: Process.neutral);
        }
      } else {
        // Remove id and name if phone is not valid
        if (state.collectorId != null ||
            state.collectorName != null ||
            state.transactionFeePercent != 0 ||
            state.isCollectorPhoneExist) yield state.clearCollector();
      }
    } else if (event is EventCollectorIdChanged) {
      yield state.copyWith(process: Process.processing);
      try {
        //get phone and name
        InfoReviewModel? model = await collectDealTransactionHandler
            .getInfoReview(collectorId: event.collectorId);
        if (model != null) {
          yield state.copyWith(
            process: Process.processed,
            collectorId: model.collectorId,
            collectorName: model.collectorName,
            collectorPhone: model.collectorPhone,
            transactionFeePercent: model.transactionFeePercent,
            isCollectorPhoneExist: true,
            isQRScanned: true,
          );
        }
      } catch (e) {
        yield state.clearCollector(
          collectorPhone: CustomTexts.emptyString,
          isQRScanned: true,
        );
        yield state.copyWith(process: Process.processed);
        yield state.copyWith(process: Process.error);
      } finally {
        yield state.copyWith(process: Process.neutral);
      }
    } else if (event is EventShowItemDialog) {
      yield state.copyWith(process: Process.processing);
      //clear item values
      _resetItemValue();
      // Update dropdown list
      _updateScrapCategoryMap();
      if (event.key == null || event.detail == null) {
        var itemDealerCategoryId = state.scrapCategoryMap.keys.first;
        // Get details
        if (itemDealerCategoryId != CustomVar.unnamedScrapCategory.id) {
          List<ScrapCategoryUnitModel>? details =
              await dataHandler.getScrapCategoryDetailList(
                  scrapCategoryId: itemDealerCategoryId);
          if (details != null && details.isNotEmpty) {
            state.scrapCategoryDetails = details;
            state.itemDealerCategoryDetailId = details.first.id;
            state.itemPrice = details.first.price;
          }
        }
      }
      // If item is choosen instead
      else {
        // Add scrap category back to the dropdown list
        var scrapCategory = state.scrapCategories.firstWhere(
            (element) => element.id == event.detail!.dealerCategoryId);
        _addScrapCategoryOnItemSelected(
          id: scrapCategory.id,
          name: scrapCategory.name,
        );
        // Get details
        List<ScrapCategoryUnitModel>? details;
        if (event.detail!.dealerCategoryId !=
            CustomVar.unnamedScrapCategory.id) {
          details = await dataHandler.getScrapCategoryDetailList(
              scrapCategoryId: event.detail!.dealerCategoryId);
        }
        // Add item data
        state.isNewItem = false;
        state.key = event.key;
        state.itemBonusAmount = event.detail!.bonusAmount;
        state.itemDealerCategoryDetailId = event.detail!.dealerCategoryDetailId;
        state.itemDealerCategoryId = event.detail!.dealerCategoryId;
        state.isItemTotalCalculatedByUnitPrice =
            event.detail!.isCalculatedByUnitPrice;
        state.itemPrice = event.detail!.price;
        state.itemPromotionId = event.detail!.promotionId;
        state.itemQuantity = event.detail!.quantity;
        state.itemTotal = event.detail!.total;
        state.scrapCategoryDetails = details ?? [];
        state.isPromotionApplied = event.detail!.isPromotionnApplied;
      }
      // Open dialog
      yield state.copyWith(
        isItemDialogShowed: true,
        process: Process.processed,
      );
      yield state.copyWith(isItemDialogShowed: false);
    } else if (event is EventCalculatedByUnitPriceChanged) {
      // If switched on
      yield state.copyWith(
          isItemTotalCalculatedByUnitPrice: event.isCalculatedByUnitPrice);
      //Check promotion
      _setItemPromotion();
    } else if (event is EventDealerCategoryChanged) {
      yield state.copyWith(itemDealerCategoryId: event.dealerCategoryId);
      // If not default category
      if (event.dealerCategoryId != CustomVar.unnamedScrapCategory.id) {
        try {
          //get category details
          yield state.copyWith(process: Process.processing);
          var scrapCategoryDetailList =
              await dataHandler.getScrapCategoryDetailList(
                  scrapCategoryId: event.dealerCategoryId);
          if (scrapCategoryDetailList != null)
            yield state.copyWith(
              scrapCategoryDetails: scrapCategoryDetailList,
              itemDealerCategoryDetailId: scrapCategoryDetailList.first.id,
              itemQuantity: 0,
              itemPrice: scrapCategoryDetailList.first.price,
            );
          yield state.copyWith(process: Process.processed);
        } catch (e) {
          yield state.copyWith(process: Process.processed);
          yield state.copyWith(process: Process.error);
        } finally {
          yield state.copyWith(process: Process.neutral);
        }
      }
      // If default then switch off calculated option, remove unit list, remove default unit
      else {
        yield state.copyWith(
          scrapCategoryDetails: [],
          isItemTotalCalculatedByUnitPrice: false,
          itemDealerCategoryDetailId: null,
          itemPrice: 0,
          itemQuantity: 0,
        );
      }
      //Check promotion
      _setItemPromotion();
    } else if (event is EventDealerCategoryUnitChanged) {
      var unitPrice = state.scrapCategoryDetails
          .firstWhere((element) => element.id == event.dealerCategoryDetailId)
          .price;
      if (unitPrice != null) {
        yield state.copyWith(
            itemDealerCategoryDetailId: event.dealerCategoryDetailId,
            itemPrice: unitPrice);
      } else {
        yield state.copyWith(
            itemDealerCategoryDetailId: event.dealerCategoryDetailId);
      }
      //Check promotion
      _setItemPromotion();
    } else if (event is EventItemTotalChanged) {
      var totalInt = int.tryParse(event.total);
      if (totalInt != null)
        yield state.copyWith(itemTotal: totalInt);
      else {
        yield state.copyWith(process: Process.error);
        yield state.copyWith(process: Process.neutral);
      }
      //Check promotion
      _setItemPromotion();
    } else if (event is EventQuantityChanged) {
      var quantity = double.tryParse(event.quantity);
      if (quantity != null)
        yield state.copyWith(itemQuantity: quantity);
      else {
        yield state.copyWith(
          itemQuantity: 0,
          process: Process.error,
        );
        yield state.copyWith(process: Process.neutral);
      }
      //Check promotion
      _setItemPromotion();
    } else if (event is EventUnitPriceChanged) {
      var unitPrice = int.tryParse(event.unitPrice);
      if (unitPrice != null)
        yield state.copyWith(itemPrice: unitPrice);
      else {
        yield state.copyWith(process: Process.error);
        yield state.copyWith(process: Process.neutral);
      }
      //Check promotion
      _setItemPromotion();
    } else if (event is EventAddNewItem) {
      // Put new item
      state.items.add(CollectDealTransactionDetailModel(
        dealerCategoryId: state.itemDealerCategoryId,
        dealerCategoryDetailId: state.itemDealerCategoryDetailId,
        quantity: state.itemQuantity,
        unit: state.itemDealerCategoryDetailId != null
            ? state.scrapCategoryDetails
                .firstWhere(
                    (element) => element.id == state.itemDealerCategoryDetailId)
                .unit
            : null,
        promotionId: state.itemPromotionId,
        bonusAmount: state.itemBonusAmount,
        total: state.isItemTotalCalculatedByUnitPrice
            ? state.itemTotalCalculated
            : state.itemTotal,
        price: state.itemPrice,
        isCalculatedByUnitPrice: state.isItemTotalCalculatedByUnitPrice,
        isPromotionnApplied: state.isPromotionApplied,
      ));
      // Update category dropdown
      _updateScrapCategoryMap();
      // Update the item list
      yield state.copyWith(isItemsUpdated: true);
      yield state.copyWith(isItemsUpdated: false);
      //clear item values
      _resetItemValue();
      // Reload values
      add(EventReloadValues());
    } else if (event is EventSubmitNewTransaction) {
      //start progress indicator
      yield state.copyWith(process: Process.processing);
      try {
        // Remove quantity and price if isCalculatedByUnitPrice = false
        var items = List<CollectDealTransactionDetailModel>.from(state.items);
        items.forEach((element) {
          if (!element.isCalculatedByUnitPrice) {
            element.quantity = 0;
            element.price = 0;
          }
        });

        // Create request model
        var model = CollectDealTransactionRequestModel(
          collectorId: state.collectorId!,
          total: state.total,
          totalBonus: state.totalBonus,
          transactionFee: state.transactionFee,
          items: state.items,
        );

        String? transactionId = await collectDealTransactionHandler
            .createCollectDealTransaction(model: model);
        if (transactionId != null) {
          yield state.copyWith(process: Process.processed);
          yield state.copyWith(
              process: Process.valid, transactionId: transactionId);
        } else {
          yield state.copyWith(process: Process.processed);
          yield state.copyWith(process: Process.error);
        }
      } on Exception {
        yield state.copyWith(process: Process.processed);
        yield state.copyWith(process: Process.error);
      } finally {
        yield state.copyWith(process: Process.neutral);
      }
    } else if (event is EventUpdateItem) {
      if (state.key != null) {
        // update item
        state.items[state.key!] = CollectDealTransactionDetailModel(
          dealerCategoryId: state.itemDealerCategoryId,
          dealerCategoryDetailId: state.itemDealerCategoryDetailId,
          quantity: state.itemQuantity,
          unit: state.itemDealerCategoryDetailId != null
              ? state.scrapCategoryDetails
                  .firstWhere((element) =>
                      element.id == state.itemDealerCategoryDetailId)
                  .unit
              : null,
          promotionId: state.itemPromotionId,
          bonusAmount: state.itemBonusAmount,
          total: state.isItemTotalCalculatedByUnitPrice
              ? state.itemTotalCalculated
              : state.itemTotal,
          price: state.itemPrice,
          isCalculatedByUnitPrice: state.isItemTotalCalculatedByUnitPrice,
          isPromotionnApplied: state.isPromotionApplied,
        );
        // Update category dropdown
        _updateScrapCategoryMap();
        // Update the item list
        yield state.copyWith(isItemsUpdated: true);
        yield state.copyWith(isItemsUpdated: false);
        //clear item values
        _resetItemValue();
        // Reload values
        add(EventReloadValues());
      }
    } else if (event is EventReloadValues) {
      // Recalculate total and total bonus amount
      _recalculateTotalAndBonusAmount();
      yield state.copyWith();
    } else if (event is EventDissmissPopup) {
      // Update category dropdown
      _updateScrapCategoryMap();
      yield state.copyWith();
    } else if (event is EventDeleteItem) {
      // Update items
      List<CollectDealTransactionDetailModel> items = List.from(state.items);
      items.removeAt(event.key);
      yield state.copyWith(items: items);
      // Update category dropdown
      _updateScrapCategoryMap();
      // Recalculate total and total bonus amount
      _recalculateTotalAndBonusAmount();
      // Update the item list
      yield state.copyWith(isItemsUpdated: true);
      yield state.copyWith(isItemsUpdated: false);
    }
  }

  _updateScrapCategoryMap() {
    state.items.forEach((item) {
      state.scrapCategoryMap
          .removeWhere((mapKey, mapValue) => mapKey == item.dealerCategoryId);
    });
  }

  _addScrapCategoryOnItemSelected({required id, required name}) {
    state.scrapCategoryMap.putIfAbsent(id, () => name);
  }

  _setItemPromotion() {
    //Get sublist of selected category from dropdown
    List<ScrapCategoryModel> scrapSublist = state.scrapCategories
        .where((element) => element.id == state.itemDealerCategoryId)
        .toList();
    // If there is no promotion
    if (scrapSublist.isEmpty) {
      state.itemPromotionId = null;
      state.itemBonusAmount = 0;
    }
    // If there is promotion
    else {
      // var scrapCategoryWithActivePromotion =
      //     _getScrapCategoryWithActivePromotion();
      var itemPromotionId;
      var itemBonusAmount = 0;
      var isPromotionApplied = false;
      var total = 0;
      if (state.isItemTotalCalculatedByUnitPrice)
        total = state.itemTotalCalculated;
      else
        total = state.itemTotal;
      //Searching for suitable promotion
      scrapSublist.forEach((element) {
        if (element.appliedAmount != null &&
            total >= element.appliedAmount &&
            element.bonusAmount > itemBonusAmount) {
          // Found suitable promotion
          itemPromotionId = element.promotionId;
          itemBonusAmount = element.bonusAmount;
          isPromotionApplied = true;
        }
      });
      //Set promotion
      state.itemPromotionId = itemPromotionId;
      state.itemBonusAmount = itemBonusAmount;
      state.isPromotionApplied = isPromotionApplied;
    }
  }

  _resetItemValue() {
    state.isNewItem = true;
    state.key = null;
    state.itemDealerCategoryId = state.scrapCategoryMap.isNotEmpty
        ? state.scrapCategoryMap.keys.first
        : CustomTexts.emptyString;
    state.itemDealerCategoryDetailId = null;
    state.itemQuantity = 0;
    state.itemPromotionId = null;
    state.itemBonusAmount = 0;
    state.itemTotal = 0;
    state.itemPrice = 0;
    state.isItemTotalCalculatedByUnitPrice = false;
    state.scrapCategoryDetails = [];
    state.isPromotionApplied = false;
  }

  _recalculateTotalAndBonusAmount() {
    var total = 0;
    var totalBonus = 0;
    state.items.forEach((item) {
      total += item.isCalculatedByUnitPrice ? item.totalCalculated : item.total;
      if (item.isPromotionnApplied) totalBonus += item.bonusAmount;
    });
    // Set value
    state.total = total;
    state.totalBonus = totalBonus;
  }
}
