import 'package:flutter/material.dart';

// 📦 Imports dos models e serviços
import '../../models/task.dart';
import '../../models/category.dart';
import '../../services/task_service.dart';
import '../../services/category_service.dart';
import '../../services/isar_service.dart';

// 🧩 Import do widget de item de tarefa
import '../widgets/task_item_widget.dart';

// 📝 Import da página de criação/edição de tarefa
import 'task_form_page.dart';

/// Página principal do app UnoList.
/// Tela responsável por listar as tarefas, aplicar filtros, buscar e navegar para outras telas.
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

/// Estado da HomePage, responsável por controlar os dados,
/// filtros, buscas e atualizações da interface.
class _HomePageState extends State<HomePage> {
  // 🛠️ Serviços que acessam o banco de dados (via Isar)
  late final TaskService _taskService;
  late final CategoryService _categoryService;

  // 📦 Estado da lista de tarefas e categorias
  List<Task> tasks = [];
  List<Category> categories = [];

  // 🎯 Estado dos filtros e busca
  String selectedFilter = 'All'; // Filtro atual
  String searchQuery = '';       // Termo de busca

  @override
  void initState() {
    super.initState();
    _initializeServices(); // 🚀 Inicializa os serviços e carrega os dados
  }

  /// 🚀 Inicializa os serviços Task e Category com o banco Isar
  Future<void> _initializeServices() async {
    final isar = await IsarService().db;

    _taskService = TaskService(isar);
    _categoryService = CategoryService(isar);

    await _loadData();
  }

  /// 🔄 Carrega tarefas e categorias do banco de dados
  Future<void> _loadData() async {
    final loadedTasks = await _taskService.getAllTasks();
    final loadedCategories = await _categoryService.getAllCategories();

    setState(() {
      tasks = loadedTasks;
      categories = loadedCategories;
    });
  }

  /// 🔎 Obtém o nome da categoria pelo ID
  String getCategoryName(int? categoryId) {
    final category = categories.firstWhere(
          (cat) => cat.id == categoryId,
      orElse: () => Category(
        name: 'Uncategorized',
        color: 0xFF9E9E9E, // Cinza padrão
        createdAt: DateTime.now(),
      ),
    );
    return category.name;
  }

  @override
  Widget build(BuildContext context) {
    // 🧠 Aplica filtro e busca na lista de tarefas
    final filteredTasks = tasks.where((task) {
      final matchesSearch = task.title
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      final matchesFilter = selectedFilter == 'All' ||
          getCategoryName(task.categoryId) == selectedFilter;

      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      // 🧭 AppBar superior
      appBar: AppBar(
        title: const Text('UnoList'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData, // 🔄 Atualiza a lista manualmente
          ),
        ],
      ),

      // 🏗️ Corpo da página
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Espaçamento geral
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔍 Barra de busca
              _buildSearchBar(),

              const SizedBox(height: 16),

              // 🏷️ Filtros de categorias
              _buildFilterChips(),

              const SizedBox(height: 16),

              // 📋 Lista de tarefas
              Expanded(
                child: _buildTaskList(filteredTasks),
              ),
            ],
          ),
        ),
      ),

      // ➕ Botão flutuante para adicionar nova tarefa
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TaskFormPage(),
            ),
          );
          _loadData(); // 🔄 Atualiza após voltar da TaskFormPage
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  /// 🔍 Widget da barra de busca
  Widget _buildSearchBar() {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Search', // Texto de dica
        prefixIcon: Icon(Icons.search), // Ícone de lupa
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (value) {
        setState(() {
          searchQuery = value;
        });
      },
    );
  }

  /// 🏷️ Widget dos filtros de categoria
  Widget _buildFilterChips() {
    // Monta a lista de filtros: "All" + nomes das categorias
    final filters = ['All', ...categories.map((c) => c.name).toList()];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final bool isSelected = selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  selectedFilter = filter;
                });
              },
              selectedColor: Colors.blue,
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 📋 Widget da lista de tarefas
  Widget _buildTaskList(List<Task> filteredTasks) {
    if (filteredTasks.isEmpty) {
      return const Center(
        child: Text(
          'No tasks found',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        final task = filteredTasks[index];

        return TaskItemWidget(
          title: task.title,
          category: getCategoryName(task.categoryId),
          date: task.dueDate != null
              ? '${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}'
              : '',
          isCompleted: task.isCompleted,
          onToggleComplete: () async {
            setState(() {
              task.isCompleted = !task.isCompleted;
            });
            await _taskService.updateTask(task);
          },
          onTap: () {
            // 🚧 Aqui futuramente abrirá a edição da tarefa.
            // Poderia navegar para TaskFormPage passando os dados da task.
          },
        );
      },
    );
  }
}
