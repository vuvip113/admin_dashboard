import 'dart:io';

import 'package:admin_dashboard/core/errors/exception.dart';
import 'package:admin_dashboard/data/category/models/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class CategoryDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<void> addCategory(CategoryModel category, {File? imageFile});
}

class CategoryDataSourceImpl implements CategoryDataSource {
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
}
