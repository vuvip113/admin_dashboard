import 'dart:io';

import 'package:admin_dashboard/core/utils/constants/tydefs.dart';
import 'package:admin_dashboard/domain/category/entities/category.dart';

abstract class CategoryRepo {
  ResultFuture<List<Category>> getCategories();
  ResultVoid addCategory(Category category, File? image);
}
