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

  @override
  List<Object?> get props => [id, name, imageUrl, createdAt];
}
