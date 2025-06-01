import 'package:flutter/material.dart';
import '../../models/category.dart';

/// Widget que exibe uma categoria individual em uma lista.
class CategoryItemWidget extends StatelessWidget {
  final Category category;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CategoryItemWidget({
    Key? key,
    required this.category,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Color(category.color),
      ),
      title: Text(category.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
