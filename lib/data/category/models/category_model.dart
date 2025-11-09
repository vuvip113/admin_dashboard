// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:admin_dashboard/domain/category/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    super.imageUrl,
    required super.createdAt,
  });

  CategoryModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      imageUrl: category.imageUrl,
      createdAt: category.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as String,
      name: map['name'] as String,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, imageUrl: $imageUrl, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant CategoryModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.imageUrl == imageUrl &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ imageUrl.hashCode ^ createdAt.hashCode;
  }
}
