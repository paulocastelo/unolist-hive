import 'package:flutter/material.dart';

/// 📦 Centraliza diálogos customizados da aplicação
class CustomDialogs {
  /// 🔄 Mostra um diálogo de confirmação
  static Future<bool?> showConfirmationDialog(
      BuildContext context, {
        required String title,
        required String content,
        String confirmText = 'Confirm',
        String cancelText = 'Cancel',
      }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
}
