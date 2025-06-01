import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:hive/hive.dart';

// 📦 Imports dos models
import '../../models/category.dart';
import '../../models/task.dart';

// 📦 Imports dos serviços
import '../../services/category_service.dart';
import '../../services/task_service.dart';

/// Página de criação e edição de tarefas.
/// Permite cadastrar título, descrição, categoria, data e status da tarefa.
class TaskFormPage extends StatefulWidget {
  final Task? task;

  const TaskFormPage({super.key, this.task});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  // 🛠️ Serviços que acessam o banco de dados
  late final TaskService _taskService;
  late final CategoryService _categoryService;

  // 🧠 Controladores dos campos de texto
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  // 📦 Estado dos campos do formulário
  List<Category> categories = [];
  Category? selectedCategory;
  DateTime? selectedDate;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _loadCategories();
  }

  /// 🚀 Inicializa os serviços
  void _initializeServices() {
    final taskBox = Hive.box<Task>('tasks');
    final categoryBox = Hive.box<Category>('categories');

    _taskService = TaskService(taskBox);
    _categoryService = CategoryService(categoryBox: categoryBox, taskBox: taskBox);
  }

  /// 🔽 Carrega categorias do banco de dados
  Future<void> _loadCategories() async {
    final loadedCategories = await _categoryService.getAllCategories();
    setState(() {
      categories = loadedCategories;

      // 🧠 Se for edição, preencher os campos agora que carregou as categorias
      if (widget.task != null) {
        final task = widget.task!;
        _titleController.text = task.title;
        _descriptionController.text = task.description ?? '';
        selectedCategory =
            categories.firstWhereOrNull((c) => c.id == task.categoryId);
        selectedDate = task.dueDate;
        isCompleted = task.isCompleted;
      }
    });
  }

  /// 📅 Abre o seletor de data
  Future<void> _selectDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  /// 💾 Salva a tarefa no banco (criar ou editar)
  Future<void> _saveTask() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title is required')),
      );
      return;
    }

    if (widget.task == null) {
      // ➕ Criação
      await _taskService.addTask(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        dueDate: selectedDate,
        categoryId: selectedCategory?.id,
        priority: 'Média',
      );
    } else {
      // ✏️ Edição
      final updated = widget.task!
        ..title = _titleController.text.trim()
        ..description = _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim()
        ..categoryId = selectedCategory?.id
        ..dueDate = selectedDate
        ..isCompleted = isCompleted;

      await _taskService.updateTask(updated);
    }

    Navigator.pop(context);
  }

  /// 🗑️ Confirmação e deleção da tarefa
  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _taskService.deleteTask(widget.task!.id);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔵 AppBar dinâmica com botão de deletar se for edição
      appBar: AppBar(
        title: Text(widget.task == null ? 'New Task' : 'Edit Task'),
        actions: widget.task != null
            ? [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _confirmDelete,
          ),
        ]
            : null,
      ),

      // 🏗️ Corpo da página
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // 🔤 Campo Título
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                // 📝 Campo Descrição
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),

                const SizedBox(height: 16),

                // 🏷️ Dropdown de Categorias
                DropdownButtonFormField<Category>(
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedCategory,
                  items: categories
                      .map(
                        (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category.name),
                    ),
                  )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),

                const SizedBox(height: 16),

                // 📅 Campo de Data (Date Picker)
                InkWell(
                  onTap: _selectDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Due Date',
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedDate != null
                              ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                              : 'Select a date',
                        ),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ✅ Checkbox de Status
                CheckboxListTile(
                  title: const Text('Completed'),
                  value: isCompleted,
                  onChanged: (value) {
                    setState(() {
                      isCompleted = value ?? false;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      // 💾 Botão Flutuante de Salvar
      floatingActionButton: FloatingActionButton(
        onPressed: _saveTask,
        child: const Icon(Icons.save),
      ),
    );
  }
}
