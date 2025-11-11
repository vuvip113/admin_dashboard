import 'dart:io';

import 'package:admin_dashboard/core/utils/constants/tydefs.dart';
import 'package:admin_dashboard/domain/category/entities/category.dart';
import 'package:admin_dashboard/domain/category/repo/category_repo.dart';

class UpdateCategoryUsecase {
  const UpdateCategoryUsecase(this._repo);

  final CategoryRepo _repo;

  ResultVoid call(Category category, {File? image}) async {
    return await _repo.updateCategory(category, image);
  }
}
