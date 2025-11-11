import 'dart:io';

import 'package:admin_dashboard/core/errors/exception.dart';
import 'package:admin_dashboard/core/errors/failures.dart';
import 'package:admin_dashboard/core/utils/constants/tydefs.dart';
import 'package:admin_dashboard/data/category/models/category_model.dart';
import 'package:admin_dashboard/data/category/source/category_data_source.dart';
import 'package:admin_dashboard/domain/category/entities/category.dart';
import 'package:admin_dashboard/domain/category/repo/category_repo.dart';
import 'package:dartz/dartz.dart';

class CategoryRepoImpl implements CategoryRepo {
  const CategoryRepoImpl(this._categoryDataSource);
  final CategoryDataSource _categoryDataSource;

  @override
  ResultFuture<List<Category>> getCategories() async {
    try {
      final result = await _categoryDataSource.getCategories();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultVoid addCategory(Category category, File? image) async {
    try {
      final categoryModel = CategoryModel.fromEntity(category);

      await _categoryDataSource.addCategory(categoryModel, imageFile: image);

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultVoid updateCategory(Category category, File? image) async {
    try {
      final categoryModel = CategoryModel.fromEntity(category);

      await _categoryDataSource.updateCategory(
        categoryModel,
        newImageFile: image,
      );

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultVoid deleteCategory(String id) async {
    try {
      final future = _categoryDataSource.deleteCategory(id);
      return Future.value(future).then((_) => const Right(null));
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
