import 'package:admin_dashboard/core/usecase/usecase.dart';
import 'package:admin_dashboard/core/utils/constants/tydefs.dart';
import 'package:admin_dashboard/domain/category/entities/category.dart';
import 'package:admin_dashboard/domain/category/repo/category_repo.dart';

class GetCategoryUsecase implements UsecaseWithoutParams<List<Category>> {
  const GetCategoryUsecase(this._repo);

  final CategoryRepo _repo;

  @override
  ResultFuture<List<Category>> call() async {
    return await _repo.getCategories();
  }
}
