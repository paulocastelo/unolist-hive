import 'package:flutter/material.dart';

// 📦 Imports dos models e serviços
import '../../models/category.dart';
import '../../models/task.dart';
import '../../services/category_service.dart';
import '../../services/task_service.dart';
import '../../services/isar_service.dart';

/// Página de criação e edição de tarefas.
/// Permite cadastrar título, descrição, categoria, data e status da tarefa.
class TaskFormPage extends StatefulWidget {
  const TaskFormPage({Key? key}) : super(key: key);

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
  List<Category> categories = []; // Lista de categorias disponíveis
  Category? selectedCategory;     // Categoria selecionada
  DateTime? selectedDate;         // Data selecionada
  bool isCompleted = false;       // Status da tarefa (concluído ou não)

  @override
  void initState() {
    super.initState();
    _initializeServices(); // 🚀 Inicializa os serviços e carrega as categorias
  }

  /// 🚀 Inicializa os serviços e carrega as categorias do banco
  Future<void> _initializeServices() async {
    final isar = await IsarService().db;

    _taskService = TaskService(isar);
    _categoryService = CategoryService(isar);

    await _loadCategories();
  }

  /// 🔽 Carrega categorias do banco de dados
  Future<void> _loadCategories() async {
    final loadedCategories = await _categoryService.getAllCategories();
    setState(() {
      categories = loadedCategories;
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

  /// 💾 Salva a tarefa no banco
  Future<void> _saveTask() async {
    // 🔍 Validação simples: título é obrigatório
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title is required')),
      );
      return;
    }

    // 🏗️ Cria o objeto da tarefa com os dados preenchidos
    final newTask = Task.create(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      dueDate: selectedDate,
      priority: 'Média', // 🔥 Definido como padrão (pode ser dinâmico no futuro)
      categoryId: selectedCategory?.id,
    )
      ..isCompleted = isCompleted; // ✅ Status (permitindo salvar como concluído)

    // 💾 Salva no banco
    await _taskService.addTask(newTask);

    // 🔙 Volta para a tela anterior
    Navigator.pop(context);
  }

  @override
  void dispose() {
    // 🧹 Libera os controladores de texto
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔵 AppBar superior
      appBar: AppBar(
        title: const Text('New Task'),
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
