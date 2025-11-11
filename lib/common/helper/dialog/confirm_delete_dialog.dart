// lib/presentation/categories/widgets/confirm_delete_dialog.dart

import 'package:flutter/material.dart';

/// Hiển thị dialog xác nhận xóa
/// Trả về `true` nếu người dùng xác nhận xóa, `false` hoặc null nếu hủy
Future<bool?> showConfirmDeleteDialog({
  required BuildContext context,
  required String itemName, // tên đối tượng cần xóa
}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Xác nhận xóa'),
      content: Text('Bạn có chắc chắn muốn xóa "$itemName" không?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Hủy'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('Xóa', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
