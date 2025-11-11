import 'dart:io';
import 'package:flutter/material.dart';

class CategoryImageCard extends StatelessWidget {
  final String labelText;
  final File? imageFile; // Ảnh mới user chọn
  final String? imageUrlForUpdateImage; // Ảnh cũ từ server
  final VoidCallback onTap;

  const CategoryImageCard({
    super.key,
    required this.labelText,
    this.imageFile,
    this.imageUrlForUpdateImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ImageProvider? imageProvider;

    if (imageFile != null) {
      imageProvider = FileImage(imageFile!); // ảnh mới
    } else if (imageUrlForUpdateImage != null &&
        imageUrlForUpdateImage!.startsWith('http')) {
      imageProvider = NetworkImage(imageUrlForUpdateImage!); // ảnh cũ
    }

    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Container(
          height: 200,
          width: size.width * 0.12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
            image: imageProvider != null
                ? DecorationImage(image: imageProvider, fit: BoxFit.cover)
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imageProvider == null)
                Icon(Icons.camera_alt, size: 50, color: Colors.grey[600]),
              const SizedBox(height: 8),
              Text(
                labelText,
                style: TextStyle(fontSize: 14, color: Colors.grey[800]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
