import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String? imageUrl;
  final DateTime createdAt;

  const Category({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.createdAt,
  });

  // ✅ Thêm hàm copyWith
  Category copyWith({
    String? id,
    String? name,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, name, imageUrl, createdAt];
}
