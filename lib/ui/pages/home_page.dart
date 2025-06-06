import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// 📦 Imports dos models e serviços
import '../../models/task.dart';
import '../../models/category.dart';
import '../../services/task_service.dart';
import '../../services/category_service.dart';
import '../../services/score_service.dart';

// 🧩 Imports dos widgets
import '../widgets/main_drawer.dart';
import '../widgets/task_item_widget.dart';
import '../widgets/filter_chip_widget.dart';

// 📝 Imports das páginas
import 'task_form_page.dart';

/// Página principal do app UnoList.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TaskService _taskService;
  late final CategoryService _categoryService;
  late final ScoreService _scoreService;

  List<Task> tasks = [];
  List<Category> categories = [];
  int score = 0;

  String selectedFilter = 'All';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  void _initializeServices() {
    final taskBox = Hive.box<Task>('tasks');
    final categoryBox = Hive.box<Category>('categories');
    final scoreBox = Hive.box<int>('score');
    _scoreService = ScoreService(scoreBox);
    _taskService = TaskService(taskBox);
    _categoryService = CategoryService(categoryBox: categoryBox, taskBox: taskBox);
    _loadData();
  }

  Future<void> _loadData() async {
    final loadedTasks = await _taskService.getAllTasks();
    final loadedCategories = await _categoryService.getAllCategories();
    final currentScore = await _scoreService.getScore();

    setState(() {
      tasks = loadedTasks;
      categories = loadedCategories;
      score = currentScore;
    });
  }

  String getCategoryName(String? categoryId) {
    final category = categories.firstWhere(
          (cat) => cat.id == categoryId,
      orElse: () => Category(
        id: 'uncategorized',
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(child: Text('Pontos: $score')),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      drawer: const MainDrawer(),
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

  Widget _buildFilterChips() {
    final filters = ['All', ...categories.map((c) => c.name)];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChipWidget(
              label: filter,
              isSelected: isSelected,
              onSelected: () {
                setState(() {
                  selectedFilter = filter;
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

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
          level: task.level,
          onToggleComplete: () async {
            final wasCompleted = task.isCompleted;
            setState(() {
              task.isCompleted = !task.isCompleted;
            });
            await _taskService.updateTask(task);
            if (!wasCompleted && task.isCompleted) {
              await _scoreService.incrementScore();
              final current = await _scoreService.getScore();
              setState(() {
                score = current;
              });
            }
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
