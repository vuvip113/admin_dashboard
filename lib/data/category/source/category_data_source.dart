import 'dart:io';

import 'package:admin_dashboard/core/errors/exception.dart';
import 'package:admin_dashboard/data/category/models/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class CategoryDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<void> addCategory(CategoryModel category, {File? imageFile});
  Future<void> updateCategory(CategoryModel category, {File? newImageFile});
  Future<void> deleteCategory(String id);
}

class CategoryDataSourceImpl implements CategoryDataSource {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Categories')
          .orderBy('createdAt', descending: true)
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

  @override
  Future<void> addCategory(CategoryModel category, {File? imageFile}) async {
    try {
      String? imageUrl;

      if (imageFile != null) {
        // sanitize tên file
        final safeName = category.name.replaceAll(RegExp(r'[^\w\s-]'), '');
        final fileName = "$safeName.png"; // sẽ lưu trong Firestore

        final ref = FirebaseStorage.instance.ref().child(
          'Categories/Images/$fileName',
        );

        // Upload file kèm content type
        final metadata = SettableMetadata(contentType: 'image/png');
        await ref.putFile(imageFile, metadata);

        // Lưu tên file (không phải URL) vào Firestore
        imageUrl = fileName; // "test.png"
      }

      final docRef = FirebaseFirestore.instance.collection('Categories').doc();

      final categoryMap = category.toMap();
      categoryMap['id'] = docRef.id;

      if (imageUrl != null) {
        categoryMap['imageUrl'] = imageUrl;
      }

      await docRef.set(categoryMap);
    } catch (e) {
      throw ServerException(
        massage: 'Failed to add category: $e',
        statusCode: 400,
      );
    }
  }

  @override
  Future<void> updateCategory(
    CategoryModel category, {
    File? newImageFile,
  }) async {
    try {
      final docRef = _firestore.collection('Categories').doc(category.id);

      String? newImageName;

      if (newImageFile != null) {
        // Xóa ảnh cũ nếu có
        if (category.imageUrl != null && category.imageUrl!.isNotEmpty) {
          try {
            await _storage
                .ref('Categories/Images/${category.imageUrl}')
                .delete();
          } catch (_) {
            // không cần throw nếu file cũ không tồn tại
          }
        }

        // Upload ảnh mới
        final safeName = category.name.replaceAll(RegExp(r'[^\w\s-]'), '');
        final fileName = "$safeName.png";

        final ref = _storage.ref().child('Categories/Images/$fileName');
        final metadata = SettableMetadata(contentType: 'image/png');
        await ref.putFile(newImageFile, metadata);

        newImageName = fileName;
      }

      final updatedData = category.toMap()
        ..remove('id')
        ..['updatedAt'] = FieldValue.serverTimestamp();

      if (newImageName != null) {
        updatedData['imageUrl'] = newImageName;
      }

      await docRef.update(updatedData);
    } catch (e) {
      throw ServerException(
        massage: 'Failed to update category: $e',
        statusCode: 400,
      );
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    try {
      final docRef = _firestore.collection('Categories').doc(id);

      // 1. Lấy thông tin category hiện tại
      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        throw ServerException(massage: 'Category not found', statusCode: 404);
      }

      final data = docSnapshot.data();
      final imageUrl = data?['imageUrl'] as String?;

      // 2. Xóa ảnh trong Firebase Storage nếu có
      if (imageUrl != null && imageUrl.isNotEmpty) {
        try {
          await _storage.ref('Categories/Images/$imageUrl').delete();
        } catch (_) {
          // Nếu ảnh không tồn tại, không cần throw
        }
      }

      // 3. Xóa document trong Firestore
      await docRef.delete();
    } catch (e) {
      throw ServerException(
        massage: 'Failed to update category: $e',
        statusCode: 400,
      );
    }
  }
}
