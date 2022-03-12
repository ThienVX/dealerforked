import 'package:dealer_app/repositories/models/collect_deal_transaction_detail_model.dart';
import 'package:dealer_app/repositories/models/collector_phone_model.dart';
import 'package:dealer_app/repositories/models/scrap_category_model.dart';
import 'package:dealer_app/repositories/models/scrap_category_unit_model.dart';
import 'package:dealer_app/utils/param_util.dart';

class CreateTransactionState {
  String? collectorId;
  String collectorPhone;
  String? collectorName;
  int total;
  int totalBonus;
  int transactionFeePercent;

  List<CollectDealTransactionDetailModel> items;

  Process process;
  bool isModalBottomSheetShowed;
  bool isItemsUpdated;
  bool isCollectorPhoneExist;
  bool isQRScanned;

  //item data
  bool isNewItem;
  int? key;
  String itemDealerCategoryId;
  String? itemDealerCategoryDetailId;
  String? itemPromotionId;
  int itemBonusAmount;
  int itemTotal;
  double itemQuantity;
  int itemPrice;
  bool isItemTotalCalculatedByUnitPrice;
  List<ScrapCategoryUnitModel> scrapCategoryDetails;
  bool isPromotionApplied;

  //data
  List<ScrapCategoryModel> scrapCategories;
  Map<String, String>
      scrapCategoryMap; //map contains unique categories <id, name> for dropdown list
  List<CollectorPhoneModel> collectorPhoneList;

  String? transactionId;

  int get itemTotalCalculated {
    if (isItemTotalCalculatedByUnitPrice && itemPrice != 0)
      return (itemPrice * itemQuantity).truncate();
    else
      return 0;
  }

  int get initialUnitPrice {
    if (scrapCategoryDetails.isNotEmpty &&
        itemDealerCategoryDetailId != CustomTexts.emptyString) {
      return scrapCategoryDetails
          .firstWhere((element) => element.id == itemDealerCategoryDetailId)
          .price;
    }
    return itemPrice;
  }

  int get grandTotal {
    return total + totalBonus;
  }

  String get getItemPromotionCode {
    return scrapCategories
        .singleWhere((element) => element.promotionId == itemPromotionId)
        .promotionCode;
  }

  int get transactionFee {
    return transactionFeePercent * grandTotal;
  }

  //validators
  bool get isScrapCategoryValid {
    if (itemDealerCategoryId == CustomTexts.emptyString ||
        (isItemTotalCalculatedByUnitPrice &&
            itemDealerCategoryId == CustomVar.unnamedScrapCategory.id)) {
      return false;
    } else
      return true;
  }

  bool get isScrapCategoryUnitValid {
    if (isItemTotalCalculatedByUnitPrice) {
      if (itemDealerCategoryDetailId == CustomTexts.emptyString ||
          itemDealerCategoryDetailId == null) {
        return false;
      } else
        return true;
    } else
      return true;
  }

  bool get isItemQuantityValid {
    if (isItemTotalCalculatedByUnitPrice) {
      if (itemQuantity <= 0) {
        return false;
      } else
        return true;
    } else
      return true;
  }

  bool get isItemPriceValid {
    if (isItemTotalCalculatedByUnitPrice) {
      if (itemPrice < 0) {
        return false;
      } else
        return true;
    } else
      return true;
  }

  bool get isItemTotalLowerThanZero {
    if (isItemTotalCalculatedByUnitPrice) {
      if (itemTotalCalculated <= 0) {
        return false;
      } else
        return true;
    } else {
      if (itemTotal <= 0) {
        return false;
      } else
        return true;
    }
  }

  bool get isItemTotalUnderLimit {
    if (isItemTotalCalculatedByUnitPrice) {
      if (itemTotalCalculated >= CustomVar.totalLimit) {
        return false;
      } else
        return true;
    } else {
      if (itemTotal >= CustomVar.totalLimit) {
        return false;
      } else
        return true;
    }
  }

  bool get isPhoneValid =>
      RegExp(CustomRegexs.phoneRegex).hasMatch(collectorPhone);

  CreateTransactionState({
    String? collectorId,
    String? collectorPhone,
    String? collectorName,
    int? total,
    int? totalBonus,
    int? transactionFeePercent,
    List<CollectDealTransactionDetailModel>? items,
    Process? process,
    bool? isModalBottomSheetShowed,
    bool? isItemsUpdated,
    bool? isCollectorPhoneExist,
    bool? isQRScanned,
    //New item
    bool? isNewItem,
    int? key,
    String? itemDealerCategoryId,
    String? itemDealerCategoryDetailId,
    double? itemQuantity,
    String? itemPromotionId,
    int? itemBonusAmount,
    int? itemTotal,
    int? itemPrice,
    bool? isItemTotalCalculatedByUnitPrice,
    List<ScrapCategoryUnitModel>? scrapCategoryDetails,
    bool? isPromotionApplied,
    //Data
    List<ScrapCategoryModel>? scrapCategories,
    Map<String, String>? scrapCategoryMap,
    List<CollectorPhoneModel>? collectorPhoneList,
    String? transactionId,
  })  : collectorId = collectorId,
        collectorPhone = collectorPhone ?? '',
        collectorName = collectorName,
        total = total ?? 0,
        totalBonus = totalBonus ?? 0,
        transactionFeePercent = transactionFeePercent ?? 0,
        items = items ?? [],
        process = process ?? Process.neutral,
        isModalBottomSheetShowed = isModalBottomSheetShowed ?? false,
        isItemsUpdated = isItemsUpdated ?? false,
        isCollectorPhoneExist = isCollectorPhoneExist ?? false,
        isQRScanned = isQRScanned ?? false,
        //New item
        isNewItem = isNewItem ?? true,
        key = key,
        itemDealerCategoryId =
            itemDealerCategoryId ?? CustomVar.unnamedScrapCategory.id,
        itemDealerCategoryDetailId = itemDealerCategoryDetailId,
        itemQuantity = itemQuantity ?? 0,
        itemPromotionId = itemPromotionId,
        itemBonusAmount = itemBonusAmount ?? 0,
        itemTotal = itemTotal ?? 0,
        itemPrice = itemPrice ?? 0,
        isItemTotalCalculatedByUnitPrice =
            isItemTotalCalculatedByUnitPrice ?? false,
        scrapCategoryDetails = scrapCategoryDetails ?? [],
        isPromotionApplied = isPromotionApplied ?? false,
        //Data
        scrapCategories = scrapCategories ?? [],
        scrapCategoryMap = scrapCategoryMap ?? {},
        collectorPhoneList = collectorPhoneList ?? [],
        transactionId = transactionId;

  CreateTransactionState copyWith({
    String? collectorId,
    String? collectorPhone,
    String? collectorName,
    int? total,
    int? totalBonus,
    int? transactionFeePercent,
    List<CollectDealTransactionDetailModel>? items,
    Process? process,
    bool? isItemDialogShowed,
    bool? isItemsUpdated,
    bool? isCollectorPhoneExist,
    bool? isQRScanned,
    //New item
    bool? isNewItem,
    int? key,
    String? itemDealerCategoryId,
    String? itemDealerCategoryDetailId,
    double? itemQuantity,
    String? itemPromotionId,
    int? itemBonusAmount,
    int? itemTotal,
    int? itemPrice,
    bool? isItemTotalCalculatedByUnitPrice,
    List<ScrapCategoryUnitModel>? scrapCategoryDetails,
    bool? isPromotionApplied,
    //Data
    List<ScrapCategoryModel>? scrapCategories,
    Map<String, String>? scrapCategoryMap,
    List<CollectorPhoneModel>? collectorPhoneList,
    String? transactionId,
  }) {
    return CreateTransactionState(
      collectorId: collectorId ?? this.collectorId,
      collectorPhone: collectorPhone ?? this.collectorPhone,
      collectorName: collectorName ?? this.collectorName,
      total: total ?? this.total,
      totalBonus: totalBonus ?? this.totalBonus,
      transactionFeePercent:
          transactionFeePercent ?? this.transactionFeePercent,
      items: items ?? this.items,
      process: process ?? this.process,
      isModalBottomSheetShowed:
          isItemDialogShowed ?? this.isModalBottomSheetShowed,
      isItemsUpdated: isItemsUpdated ?? this.isItemsUpdated,
      isCollectorPhoneExist:
          isCollectorPhoneExist ?? this.isCollectorPhoneExist,
      isQRScanned: isQRScanned ?? this.isQRScanned,
      //New item
      isNewItem: isNewItem ?? this.isNewItem,
      key: key ?? this.key,
      itemDealerCategoryId: itemDealerCategoryId ?? this.itemDealerCategoryId,
      itemDealerCategoryDetailId:
          itemDealerCategoryDetailId ?? this.itemDealerCategoryDetailId,
      itemQuantity: itemQuantity ?? this.itemQuantity,
      itemPromotionId: itemPromotionId ?? this.itemPromotionId,
      itemBonusAmount: itemBonusAmount ?? this.itemBonusAmount,
      itemTotal: itemTotal ?? this.itemTotal,
      itemPrice: itemPrice ?? this.itemPrice,
      isItemTotalCalculatedByUnitPrice: isItemTotalCalculatedByUnitPrice ??
          this.isItemTotalCalculatedByUnitPrice,
      scrapCategoryDetails: scrapCategoryDetails ?? this.scrapCategoryDetails,
      isPromotionApplied: isPromotionApplied ?? this.isPromotionApplied,
      //Data
      scrapCategories: scrapCategories ?? this.scrapCategories,
      scrapCategoryMap: scrapCategoryMap ?? this.scrapCategoryMap,
      collectorPhoneList: collectorPhoneList ?? this.collectorPhoneList,
      transactionId: transactionId ?? transactionId,
    );
  }

  CreateTransactionState clearCollector(
      {String? collectorPhone, bool? isQRScanned}) {
    return CreateTransactionState(
      collectorId: null,
      collectorPhone: collectorPhone ?? this.collectorPhone,
      collectorName: null,
      total: this.total,
      totalBonus: this.totalBonus,
      transactionFeePercent: null,
      items: this.items,
      process: this.process,
      isModalBottomSheetShowed: this.isModalBottomSheetShowed,
      isItemsUpdated: this.isItemsUpdated,
      isCollectorPhoneExist: false,
      isQRScanned: isQRScanned ?? this.isQRScanned,
      //New item
      isNewItem: this.isNewItem,
      key: this.key,
      itemDealerCategoryId: this.itemDealerCategoryId,
      itemDealerCategoryDetailId: this.itemDealerCategoryDetailId,
      itemQuantity: this.itemQuantity,
      itemPromotionId: this.itemPromotionId,
      itemBonusAmount: this.itemBonusAmount,
      itemTotal: this.itemTotal,
      itemPrice: this.itemPrice,
      isItemTotalCalculatedByUnitPrice: this.isItemTotalCalculatedByUnitPrice,
      scrapCategoryDetails: this.scrapCategoryDetails,
      isPromotionApplied: this.isPromotionApplied,
      //data
      scrapCategories: this.scrapCategories,
      scrapCategoryMap: this.scrapCategoryMap,
      collectorPhoneList: this.collectorPhoneList,
    );
  }
}
