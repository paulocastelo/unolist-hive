import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../models/category.dart';
import '../models/task.dart';

/// 🎯 Serviço responsável por exportação, importação e truncamento de dados (Backup).
class BackupService {
  final Box<Task> taskBox;
  final Box<Category> categoryBox;

  /// 🚀 Construtor recebe as instâncias das boxes abertas
  BackupService({required this.taskBox, required this.categoryBox});

  // ─────────────────────────────────────────────────────────────────────────────
  // 🔥 BACKUP COMPLETO E RESTORE
  // ─────────────────────────────────────────────────────────────────────────────

  /// 💾 Faz o backup completo em JSON (string)
  Future<String> exportFullBackup() async {
    final tasks = taskBox.values.map(_taskToMap).toList();
    final categories = categoryBox.values.map(_categoryToMap).toList();

    final data = {
      'tasks': tasks,
      'categories': categories,
    };

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  /// 🔄 Faz o restore a partir de um JSON (string)
  Future<void> importFullBackup(String jsonString) async {
    final data = jsonDecode(jsonString);

    final taskList = (data['tasks'] as List)
        .map((e) => _mapToTask(Map<String, dynamic>.from(e)))
        .toList();

    final categoryList = (data['categories'] as List)
        .map((e) => _mapToCategory(Map<String, dynamic>.from(e)))
        .toList();

    await taskBox.clear();
    await categoryBox.clear();

    await taskBox.putAll({for (var task in taskList) task.id: task});
    await categoryBox.putAll({for (var category in categoryList) category.id: category});
  }

  /// 🗑️ Apaga tudo (truncate)
  Future<void> truncateAll() async {
    await taskBox.clear();
    await categoryBox.clear();
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // 🔥 EXPORTAÇÕES COM FILTROS
  // ─────────────────────────────────────────────────────────────────────────────

  /// 📦 Exporta TODOS os dados (salva em arquivo JSON)
  Future<File> exportAllData() async {
    final jsonString = await exportFullBackup();
    return _saveBackupFile(jsonString, 'backup_total');
  }

  /// 🏷️ Exporta dados por categoria
  Future<File> exportDataByCategory(int categoryId) async {
    final tasks = taskBox.values.where((task) => task.categoryId == categoryId).toList();
    final categories = categoryBox.values.where((cat) => cat.id == categoryId).toList();

    final data = {
      'tasks': tasks.map(_taskToMap).toList(),
      'categories': categories.map(_categoryToMap).toList(),
    };

    final json = const JsonEncoder.withIndent('  ').convert(data);
    return _saveBackupFile(json, 'backup_categoria_$categoryId');
  }

  /// ✔️ Exporta dados por status (concluído ou não)
  Future<File> exportDataByStatus(bool isCompleted) async {
    final tasks = taskBox.values.where((task) => task.isCompleted == isCompleted).toList();

    final categoryIds = tasks.map((t) => t.categoryId).whereType<int>().toSet();
    final categories = categoryBox.values.where((cat) => categoryIds.contains(cat.id)).toList();

    final data = {
      'tasks': tasks.map(_taskToMap).toList(),
      'categories': categories.map(_categoryToMap).toList(),
    };

    final json = const JsonEncoder.withIndent('  ').convert(data);

    return _saveBackupFile(
      json,
      isCompleted ? 'backup_concluidas' : 'backup_pendentes',
    );
  }

  /// 🗓️ Exporta dados por intervalo de datas
  Future<File> exportDataByDateRange(DateTime start, DateTime end) async {
    final tasks = taskBox.values.where((task) {
      return task.createdAt.isAfter(start) && task.createdAt.isBefore(end);
    }).toList();

    final categoryIds = tasks.map((t) => t.categoryId).whereType<int>().toSet();
    final categories = categoryBox.values.where((cat) => categoryIds.contains(cat.id)).toList();

    final data = {
      'tasks': tasks.map(_taskToMap).toList(),
      'categories': categories.map(_categoryToMap).toList(),
    };

    final json = const JsonEncoder.withIndent('  ').convert(data);

    return _saveBackupFile(
      json,
      'backup_periodo_${_formatDate(start)}_a_${_formatDate(end)}',
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // 🔄 IMPORTAÇÃO DE ARQUIVO
  // ─────────────────────────────────────────────────────────────────────────────

  /// 🔄 Importa dados a partir de um arquivo JSON
  Future<void> importData(File file) async {
    final json = await file.readAsString();
    await importFullBackup(json);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // 🔧 SERIALIZAÇÃO E DESERIALIZAÇÃO
  // ─────────────────────────────────────────────────────────────────────────────

  Map<String, dynamic> _taskToMap(Task task) => {
    'id': task.id,
    'title': task.title,
    'description': task.description,
    'dueDate': task.dueDate?.toIso8601String(), // DateTime → ISO8601
    'isCompleted': task.isCompleted,
    'priority': task.priority,
    'categoryId': task.categoryId,
    'createdAt': task.createdAt.toIso8601String(), // DateTime → ISO8601
  };

  Task _mapToTask(Map<String, dynamic> map) => Task(
    id: map['id'],
    title: map['title'],
    description: map['description'],
    dueDate: map['dueDate'] != null
        ? DateTime.parse(map['dueDate'])
        : null, // ISO8601 → DateTime
    isCompleted: map['isCompleted'],
    priority: map['priority'],
    categoryId: map['categoryId'],
    createdAt: DateTime.parse(map['createdAt']), // ISO8601 → DateTime
  );

  Map<String, dynamic> _categoryToMap(Category category) => {
    'id': category.id,
    'name': category.name,
    'color': category.color,
    'createdAt': category.createdAt.toIso8601String(), // DateTime → ISO8601
  };

  Category _mapToCategory(Map<String, dynamic> map) => Category(
    id: map['id'],
    name: map['name'],
    color: map['color'],
    createdAt: DateTime.parse(map['createdAt']), // ISO8601 → DateTime
  );

  // ─────────────────────────────────────────────────────────────────────────────
  // 💾 SALVAMENTO DE ARQUIVO
  // ─────────────────────────────────────────────────────────────────────────────

  Future<File> _saveBackupFile(String json, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final timestamp = _timestamp();
    final file = File('${dir.path}/${fileName}_$timestamp.json');
    return await file.writeAsString(json);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // 📅 FORMATAÇÃO DE NOMES E DATAS
  // ─────────────────────────────────────────────────────────────────────────────

  String _timestamp() {
    final now = DateTime.now();
    return '${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)}_${_twoDigits(now.hour)}-${_twoDigits(now.minute)}-${_twoDigits(now.second)}';
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}';
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');
}
