import 'package:admin_dashboard/domain/category/entities/category.dart';
import 'package:admin_dashboard/domain/category/usecase/get_category_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'categories_display_state.dart';

class CategoriesDisplayCubit extends Cubit<CategoriesDisplayState> {
  CategoriesDisplayCubit(this._getCategoryUsecase)
    : super(CategoriesDisplayInitial());
  final GetCategoryUsecase _getCategoryUsecase;

  Future<void> getCategories() async {
    emit(CategoriesDisplayLoading());
    final result = await _getCategoryUsecase.call();
    result.fold(
      (failure) => emit(CategoriesDisplayError(message: failure.message)),
      (categories) => emit(CategoriesDisplayLoaded(categories: categories)),
    );
  }
}
