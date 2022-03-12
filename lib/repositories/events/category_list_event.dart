import 'package:equatable/equatable.dart';

abstract class CategoryListEvent extends Equatable {}

class EventInitData extends CategoryListEvent {
  @override
  List<Object?> get props => [];
}

class EventLoadMoreCategories extends CategoryListEvent {
  @override
  List<Object?> get props => [];
}

class EventChangeSearchName extends CategoryListEvent {
  final String searchName;

  EventChangeSearchName({required this.searchName});

  @override
  List<Object> get props => [searchName];
}
