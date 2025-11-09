part of 'categories_display_cubit.dart';

sealed class CategoriesDisplayState extends Equatable {
  const CategoriesDisplayState();

  @override
  List<Object> get props => [];
}

final class CategoriesDisplayInitial extends CategoriesDisplayState {}

final class CategoriesDisplayLoading extends CategoriesDisplayState {}

class CategoriesDisplayLoaded extends CategoriesDisplayState {
  final List<Category> categories;

  const CategoriesDisplayLoaded({required this.categories});

  @override
  List<Object> get props => [categories];
}

class CategoriesDisplayError extends CategoriesDisplayState {
  final String message;

  const CategoriesDisplayError({required this.message});

  @override
  List<Object> get props => [message];
}
