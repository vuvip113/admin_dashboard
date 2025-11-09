import 'package:admin_dashboard/core/errors/exception.dart';
import 'package:admin_dashboard/data/category/models/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CategoryDataSource {
  Future<List<CategoryModel>> getCategories();
}

class CategoryDataSourceImpl implements CategoryDataSource {
  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Categories')
          .get();
          
      final categories = querySnapshot.docs.map((doc) {
        return CategoryModel.fromMap(doc.data()).copyWith(id: doc.id);
      }).toList();

      return categories;
    } catch (e) {
      throw ServerException(
        massage: 'Failed to load categories: $e',
        statusCode: 400,
      );
    }
  }
}
