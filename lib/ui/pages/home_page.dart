import 'package:flutter/material.dart';

// 📦 Imports dos models e serviços
import '../../models/task.dart';
import '../../models/category.dart';
import '../../services/task_service.dart';
import '../../services/category_service.dart';
import '../../services/isar_service.dart';

// 🧩 Import do widget de item de tarefa
import '../widgets/task_item_widget.dart';

// 📝 Import das páginas
import 'task_form_page.dart';
import 'category_page.dart';
import 'backup_page.dart';

/// Página principal do app UnoList.
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 🛠️ Serviços
  late final TaskService _taskService;
  late final CategoryService _categoryService;

  // 📦 Dados
  List<Task> tasks = [];
  List<Category> categories = [];

  // 🎯 Filtros
  String selectedFilter = 'All';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  /// 🔗 Inicializa os serviços
  Future<void> _initializeServices() async {
    final isar = await IsarService().db;
    _taskService = TaskService(isar);
    _categoryService = CategoryService(isar);
    await _loadData();
  }

  /// 🔄 Carrega tarefas e categorias
  Future<void> _loadData() async {
    final loadedTasks = await _taskService.getAllTasks();
    final loadedCategories = await _categoryService.getAllCategories();

    setState(() {
      tasks = loadedTasks;
      categories = loadedCategories;
    });
  }

  /// 🔎 Pega o nome da categoria
  String getCategoryName(int? categoryId) {
    final category = categories.firstWhere(
          (cat) => cat.id == categoryId,
      orElse: () => Category(
        name: 'Uncategorized',
        color: 0xFF9E9E9E,
        createdAt: DateTime.now(),
      ),
    );
    return category.name;
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = tasks.where((task) {
      final matchesSearch = task.title.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesFilter = selectedFilter == 'All' ||
          getCategoryName(task.categoryId) == selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('UnoList'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),

      // 🚪 Drawer de navegação
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'UnoList Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Tasks'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('Categories'),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoryPage(),
                  ),
                );
                _loadData();
              },
            ),
            ListTile(
              leading: const Icon(Icons.backup),
              title: const Text('Backup & Restore'),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BackupPage(),
                  ),
                );
                _loadData();
              },
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildFilterChips(),
              const SizedBox(height: 16),
              Expanded(child: _buildTaskList(filteredTasks)),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TaskFormPage(),
            ),
          );
          _loadData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  /// 🔍 Barra de busca
  Widget _buildSearchBar() {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Search',
        prefixIcon: Icon(Icons.search),
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

  /// 🏷️ Filtros de categoria
  Widget _buildFilterChips() {
    final filters = ['All', ...categories.map((c) => c.name).toList()];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter;

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

  /// 📋 Lista de tarefas
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
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskFormPage(task: task),
              ),
            );
            _loadData();
          },
        );
      },
    );
  }
}
