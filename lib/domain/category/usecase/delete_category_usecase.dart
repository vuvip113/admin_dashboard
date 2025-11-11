import 'package:admin_dashboard/core/usecase/usecase.dart';
import 'package:admin_dashboard/core/utils/constants/tydefs.dart';
import 'package:admin_dashboard/domain/category/entities/category.dart';
import 'package:admin_dashboard/domain/category/repo/category_repo.dart';

class DeleteCategoryUsecase implements UsecaseWithParams<void, Category> {
  const DeleteCategoryUsecase(this._repo);

  final CategoryRepo _repo;

  @override
  ResultVoid call(Category category) async {
    return await _repo.deleteCategory(category.id);
  }
}
