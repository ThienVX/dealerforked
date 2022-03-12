import 'package:dealer_app/repositories/models/scrap_category_model.dart';
import 'package:equatable/equatable.dart';

abstract class CategoryListState extends Equatable {}

class NotLoadedState extends CategoryListState {
  @override
  List<Object?> get props => [];
}

class LoadedState extends CategoryListState {
  final List<ScrapCategoryModel> categoryList;
  final List<ScrapCategoryModel> filteredCategoryList;
  final String searchName;

  LoadedState({
    required this.categoryList,
    required this.filteredCategoryList,
    this.searchName = '',
  });

  LoadedState copyWith({
    List<ScrapCategoryModel>? categoryList,
    List<ScrapCategoryModel>? filteredCategoryList,
    String? searchName,
  }) {
    return LoadedState(
      categoryList: categoryList ?? this.categoryList,
      filteredCategoryList: filteredCategoryList ?? this.filteredCategoryList,
      searchName: searchName ?? this.searchName,
    );
  }

  @override
  List<Object> get props => [categoryList, filteredCategoryList, searchName];
}

class ErrorState extends CategoryListState {
  final String errorMessage;

  ErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
