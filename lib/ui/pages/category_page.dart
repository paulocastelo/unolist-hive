import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// 📦 Imports dos models e serviços
import '../../models/category.dart';
import '../../models/task.dart';
import '../../services/category_service.dart';

// 🧩 Import do widget novo
import '../widgets/category_item_widget.dart';
import '../widgets/custom_dialogs.dart';

/// Página de gerenciamento de categorias.
class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late final CategoryService _categoryService;

  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  void _initializeService() {
    final categoryBox = Hive.box<Category>('categories');
    final taskBox = Hive.box<Task>('tasks');
    _categoryService = CategoryService(categoryBox: categoryBox, taskBox: taskBox);

    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final loaded = await _categoryService.getAllCategories();
    setState(() {
      categories = loaded;
    });
  }

  Widget _buildCategoryList() {
    if (categories.isEmpty) {
      return const Center(
        child: Text('No categories found.'),
      );
    }

    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];

        return CategoryItemWidget(
          category: category,
          onEdit: () {
            _showCategoryDialog(category: category);
          },
          onDelete: () {
            _confirmDelete(category);
          },
        );
      },
    );
  }

  Future<void> _showCategoryDialog({Category? category}) async {
    final isEditing = category != null;

    final nameController = TextEditingController(
      text: isEditing ? category.name : '',
    );

    int selectedColor = isEditing ? category.color : Colors.blue.value;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Category' : 'New Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Color:'),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () async {
                      final color = await showDialog<int>(
                        context: context,
                        builder: (_) => _colorPickerDialog(selectedColor),
                      );
                      if (color != null) {
                        setState(() {
                          selectedColor = color;
                        });
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: Color(selectedColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Name is required')),
                  );
                  return;
                }

                if (isEditing) {
                  final updated = category!
                    ..name = name
                    ..color = selectedColor;
                  await _categoryService.updateCategory(updated);
                } else {
                  await _categoryService.addCategory(name, selectedColor); // ✅ Atualizado aqui!
                }

                if (mounted) {
                  Navigator.pop(context);
                  _loadCategories();
                }
              },
              child: Text(isEditing ? 'Save' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _colorPickerDialog(int currentColor) {
    final colors = [
      Colors.red,
      Colors.pink,
      Colors.orange,
      Colors.amber,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
      Colors.brown,
      Colors.grey,
      Colors.teal,
    ];

    return AlertDialog(
      title: const Text('Select Color'),
      content: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: colors.map((color) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context, color.value);
            },
            child: CircleAvatar(
              backgroundColor: color,
              radius: 20,
              child: currentColor == color.value
                  ? const Icon(Icons.check, color: Colors.white)
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _confirmDelete(Category category) async {
    if (category.name == 'Sem Categoria') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot delete default category')),
      );
      return;
    }

    final confirm = await CustomDialogs.showConfirmationDialog(
      context,
      title: 'Delete Category',
      content: 'Are you sure you want to delete "${category.name}"?',
    );

    if (confirm == true) {
      await _categoryService.deleteCategory(category.id);
      _loadCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _buildCategoryList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCategoryDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
