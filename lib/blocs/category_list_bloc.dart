import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/repositories/events/category_list_event.dart';
import 'package:dealer_app/repositories/handlers/data_handler.dart';
import 'package:dealer_app/repositories/handlers/scrap_category_handler.dart';
import 'package:dealer_app/repositories/models/scrap_category_model.dart';
import 'package:dealer_app/repositories/states/category_list_state.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryListBloc extends Bloc<CategoryListEvent, CategoryListState> {
  final _scrapCategoryHandler = getIt.get<IScrapCategoryHandler>();
  final _dataHandler = getIt.get<IDataHandler>();

  CategoryListBloc() : super(NotLoadedState()) {
    add(EventInitData());
  }

  final _initPage = 1;
  final _pageSize = 15;
  int _currentPage = 1;

  @override
  Stream<CategoryListState> mapEventToState(CategoryListEvent event) async* {
    if (event is EventInitData) {
      yield NotLoadedState();
      try {
        _currentPage = 1;

        List<ScrapCategoryModel> categoryList =
            await _scrapCategoryHandler.getScrapCategories(
          page: _initPage,
          pageSize: _pageSize,
        );
        yield LoadedState(
          categoryList: categoryList,
          filteredCategoryList:
              _getCategoryListFiltered(categoryList: categoryList, name: ''),
        );

        // Create new list
        List<ScrapCategoryModel> categoryListWithImage = [];
        for (var item in categoryList) {
          categoryListWithImage.add(new ScrapCategoryModel.categoryListModel(
            id: item.id,
            name: item.name,
            image: item.image,
            imageUrl: item.imageUrl,
          ));
        }
        categoryListWithImage = await _addImages(list: categoryListWithImage);
        yield LoadedState(
          categoryList: categoryListWithImage,
          filteredCategoryList: _getCategoryListFiltered(
              categoryList: categoryListWithImage, name: ''),
        );
      } catch (e) {
        print(e);
        yield ErrorState(errorMessage: 'Đã có lỗi xảy ra, vui lòng thử lại');
        //  if (e.toString().contains(CustomAPIError.missingBearerToken))
        // print(e);
      }
    }
    if (event is EventLoadMoreCategories) {
      try {
        // Get new transactions
        List<ScrapCategoryModel> newList =
            await _scrapCategoryHandler.getScrapCategories(
          page: _currentPage + 1,
          pageSize: _pageSize,
        );
        // If there is more transactions
        if (newList.isNotEmpty) {
          List<ScrapCategoryModel> categoryList =
              List.from((state as LoadedState).categoryList);
          _currentPage += 1;
          categoryList.addAll(newList);

          yield (state as LoadedState).copyWith(
            categoryList: categoryList,
            filteredCategoryList: _getCategoryListFiltered(
                categoryList: categoryList,
                name: (state as LoadedState).searchName),
          );

          List<ScrapCategoryModel> categoryListWithImage = [];
          for (var item in categoryList) {
            categoryListWithImage.add(new ScrapCategoryModel.categoryListModel(
              id: item.id,
              name: item.name,
              image: item.image,
              imageUrl: item.imageUrl,
            ));
          }
          categoryListWithImage = await _addImages(list: categoryListWithImage);
          yield (state as LoadedState).copyWith(
            categoryList: categoryListWithImage,
            filteredCategoryList: _getCategoryListFiltered(
                categoryList: categoryListWithImage,
                name: (state as LoadedState).searchName),
          );
        }
      } catch (e) {
        yield ErrorState(errorMessage: 'Đã có lỗi xảy ra, vui lòng thử lại');
        //  if (e.toString().contains(CustomAPIError.missingBearerToken))
        // print(e);
      }
    }
    if (event is EventChangeSearchName) {
      yield (state as LoadedState).copyWith(
        searchName: event.searchName,
        filteredCategoryList: _sortedList(
          _getCategoryListFiltered(
              categoryList: (state as LoadedState).categoryList,
              name: event.searchName),
        ),
      );
    }
  }

  List<ScrapCategoryModel> _sortedList(List<ScrapCategoryModel> list) {
    list.sort((a, b) => a.name.compareTo(b.name));
    return list;
  }

  Future<List<ScrapCategoryModel>> _addImages(
      {required List<ScrapCategoryModel> list}) async {
    for (var item in list) {
      if (item.imageUrl != CustomTexts.emptyString)
        item.image = await _dataHandler.getImageBytes(imageUrl: item.imageUrl);
      else
        item.image = null;
    }
    return list;
  }

  List<ScrapCategoryModel> _getCategoryListFiltered({
    required List<ScrapCategoryModel> categoryList,
    required String name,
  }) {
    if (name == CustomTexts.emptyString) return categoryList;
    // Check transactionList
    if (categoryList.isEmpty) return List.empty();
    // return filtered List
    List<ScrapCategoryModel> list = categoryList
        .where((element) =>
            element.name.toLowerCase().contains(name.toLowerCase()))
        .toList();

    return list;
  }
}
