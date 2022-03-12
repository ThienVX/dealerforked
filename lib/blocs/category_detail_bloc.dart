import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/repositories/events/category_detail_event.dart';
import 'package:dealer_app/repositories/handlers/data_handler.dart';
import 'package:dealer_app/repositories/handlers/scrap_category_handler.dart';
import 'package:dealer_app/repositories/models/request_models/update_category_request_model.dart';
import 'package:dealer_app/repositories/models/scrap_category_detail_item_model.dart';
import 'package:dealer_app/repositories/models/scrap_category_detail_model.dart';
import 'package:dealer_app/repositories/states/category_detail_state.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CategoryDetailBloc
    extends Bloc<CategoryDetailEvent, CategoryDetailState> {
  final _picker = ImagePicker();
  final String id;
  final _scrapCategoryHandler = getIt.get<IScrapCategoryHandler>();
  final _dataHandler = getIt.get<IDataHandler>();

  CategoryDetailBloc({required this.id}) : super(CategoryDetailState()) {
    add(EventInitData());
  }

  @override
  Stream<CategoryDetailState> mapEventToState(
      CategoryDetailEvent event) async* {
    if (event is EventInitData) {
      yield LoadingState(
        isImageSourceActionSheetVisible: false,
        units: null,
        pickedImageUrl: null,
        initScrapName: null,
        initScrapImage: null,
        initScrapImageUrl: null,
        scrapName: null,
        isNameExisted: false,
      );
      try {
        ScrapCategoryDetailModel model =
            await _scrapCategoryHandler.getScrapCategoryDetail(id: id);
        // Get Image
        ImageProvider? initImage;
        if (model.imageUrl != CustomTexts.emptyString)
          initImage =
              await _dataHandler.getImageBytes(imageUrl: model.imageUrl);

        yield CategoryDetailState(
          isImageSourceActionSheetVisible: false,
          isNameExisted: false,
          initScrapName: model.name,
          initScrapImage: initImage,
          initScrapImageUrl: model.imageUrl,
          scrapName: model.name,
          pickedImageUrl: null,
          units: model.details,
        );
      } catch (e) {
        yield ErrorState(
          message: CustomTexts.errorHappenedTryAgain,
          units: state.units,
          isImageSourceActionSheetVisible:
              state.isImageSourceActionSheetVisible,
          pickedImageUrl: state.pickedImageUrl,
          initScrapName: state.initScrapName,
          initScrapImage: state.initScrapImage,
          initScrapImageUrl: state.initScrapImageUrl,
          scrapName: state.scrapName,
          isNameExisted: state.isNameExisted,
        );
      }
    }
    if (event is EventChangeScrapImageRequest) {
      yield state.copyWith(isImageSourceActionSheetVisible: true);
      yield state.copyWith(isImageSourceActionSheetVisible: false);
    }
    if (event is EventOpenImagePicker) {
      final pickedImage = await _picker.pickImage(source: event.imageSource);
      if (pickedImage != null) {
        yield state.copyWith(pickedImageUrl: pickedImage.path);
      } else
        return;
    }
    if (event is EventChangeScrapName) {
      yield state.copyWith(
        scrapName: event.scrapName,
        isNameExisted: false,
      );
    }
    if (event is EventAddScrapCategoryUnit) {
      List<CategoryDetailItemModel> units = List.from(state.units);
      units.add(CategoryDetailItemModel.updateCategoryModel(
          unit: CustomTexts.emptyString));

      yield state.copyWith(units: units);
    }
    if (event is EventChangeUnitAndPrice) {
      List<CategoryDetailItemModel> units = List.from(state.units);
      units[event.index].unit = event.unit;
      units[event.index].price = int.parse(event.price);

      yield state.copyWith(units: units);
    }
    if (event is EventSubmitScrapCategory) {
      yield LoadingState(
        units: state.units,
        isImageSourceActionSheetVisible: state.isImageSourceActionSheetVisible,
        pickedImageUrl: state.pickedImageUrl,
        initScrapName: state.initScrapName,
        initScrapImage: state.initScrapImage,
        initScrapImageUrl: state.initScrapImageUrl,
        scrapName: state.scrapName,
        isNameExisted: state.isNameExisted,
      );
      try {
        // Check if name hasn't changed
        bool checkNameResult = state.scrapName == state.initScrapName;
        if (!checkNameResult)
          checkNameResult =
              await _scrapCategoryHandler.checkScrapName(name: state.scrapName);
        print(checkNameResult);
        if (checkNameResult) {
          String imagePath = state.initScrapImageUrl;
          if (state.pickedImageUrl.isNotEmpty) {
            // Upload image
            imagePath = await _scrapCategoryHandler.uploadImage(
                imagePath: state.pickedImageUrl);
          }

          // Submit category
          var result = await _scrapCategoryHandler.updateScrapCategory(
            model: UpdateScrapCategoryRequestModel(
              id: id,
              name: state.scrapName,
              imageUrl: imagePath,
              details: await _getListFiltered(units: state.units),
            ),
          );

          if (result) {
            yield SubmittedState(
              message: CustomTexts.updateScrapCategorySucessfull,
              units: state.units,
              isImageSourceActionSheetVisible:
                  state.isImageSourceActionSheetVisible,
              pickedImageUrl: state.pickedImageUrl,
              initScrapName: state.initScrapName,
              initScrapImage: state.initScrapImage,
              initScrapImageUrl: state.initScrapImageUrl,
              scrapName: state.scrapName,
              isNameExisted: state.isNameExisted,
            );
          } else {
            yield ErrorState(
              message: CustomTexts.errorHappenedTryAgain,
              units: state.units,
              isImageSourceActionSheetVisible:
                  state.isImageSourceActionSheetVisible,
              pickedImageUrl: state.pickedImageUrl,
              initScrapName: state.initScrapName,
              initScrapImage: state.initScrapImage,
              initScrapImageUrl: state.initScrapImageUrl,
              scrapName: state.scrapName,
              isNameExisted: state.isNameExisted,
            );
          }
        } else {
          yield CategoryDetailState(
            units: state.units,
            isImageSourceActionSheetVisible:
                state.isImageSourceActionSheetVisible,
            pickedImageUrl: state.pickedImageUrl,
            initScrapName: state.initScrapName,
            initScrapImage: state.initScrapImage,
            initScrapImageUrl: state.initScrapImageUrl,
            scrapName: state.scrapName,
            isNameExisted: true,
          );
        }
      } catch (e) {
        print(e);
        yield ErrorState(
          message: CustomTexts.errorHappenedTryAgain,
          units: state.units,
          isImageSourceActionSheetVisible:
              state.isImageSourceActionSheetVisible,
          pickedImageUrl: state.pickedImageUrl,
          initScrapName: state.initScrapName,
          initScrapImage: state.initScrapImage,
          initScrapImageUrl: state.initScrapImageUrl,
          scrapName: state.scrapName,
          isNameExisted: state.isNameExisted,
        );
      }
    }
    if (event is EventDeleteScrapCategory) {
      yield LoadingState(
        units: state.units,
        isImageSourceActionSheetVisible: state.isImageSourceActionSheetVisible,
        pickedImageUrl: state.pickedImageUrl,
        initScrapName: state.initScrapName,
        initScrapImage: state.initScrapImage,
        initScrapImageUrl: state.initScrapImageUrl,
        scrapName: state.scrapName,
        isNameExisted: state.isNameExisted,
      );
      try {
        // Submit category
        var result = await _scrapCategoryHandler.deleteScrapCategory(id: id);

        if (result) {
          yield SubmittedState(
            message: CustomTexts.deleteScrapCategorySucessfull,
            units: state.units,
            isImageSourceActionSheetVisible:
                state.isImageSourceActionSheetVisible,
            pickedImageUrl: state.pickedImageUrl,
            initScrapName: state.initScrapName,
            initScrapImage: state.initScrapImage,
            initScrapImageUrl: state.initScrapImageUrl,
            scrapName: state.scrapName,
            isNameExisted: state.isNameExisted,
          );
        } else {
          yield ErrorState(
            message: CustomTexts.errorHappenedTryAgain,
            units: state.units,
            isImageSourceActionSheetVisible:
                state.isImageSourceActionSheetVisible,
            pickedImageUrl: state.pickedImageUrl,
            initScrapName: state.initScrapName,
            initScrapImage: state.initScrapImage,
            initScrapImageUrl: state.initScrapImageUrl,
            scrapName: state.scrapName,
            isNameExisted: state.isNameExisted,
          );
        }
      } catch (e) {
        print(e);
        yield ErrorState(
          message: CustomTexts.errorHappenedTryAgain,
          units: state.units,
          isImageSourceActionSheetVisible:
              state.isImageSourceActionSheetVisible,
          pickedImageUrl: state.pickedImageUrl,
          initScrapName: state.initScrapName,
          initScrapImage: state.initScrapImage,
          initScrapImageUrl: state.initScrapImageUrl,
          scrapName: state.scrapName,
          isNameExisted: state.isNameExisted,
        );
      }
    }
    if (event is EventTapDeleteButton) {
      yield DeleteState(
        message: CustomTexts.deleteScrapCategory(name: state.scrapName),
        units: state.units,
        isImageSourceActionSheetVisible: state.isImageSourceActionSheetVisible,
        pickedImageUrl: state.pickedImageUrl,
        initScrapName: state.initScrapName,
        initScrapImage: state.initScrapImage,
        initScrapImageUrl: state.initScrapImageUrl,
        scrapName: state.scrapName,
        isNameExisted: state.isNameExisted,
      );
    }
  }

  Future<List<CategoryDetailItemModel>> _getListFiltered({
    required List<CategoryDetailItemModel> units,
  }) async {
    List<CategoryDetailItemModel> list = List.from(units);
    // Remove empty new unit
    list.removeWhere(
        (element) => element.unit.isEmpty && element.id == CustomVar.zeroId);
    // Change status of empty old unit
    for (var item in list) {
      if (item.id != CustomVar.zeroId && item.unit.isEmpty)
        item.status = Status.DEACTIVE.number;
    }
    return list;
  }
}
