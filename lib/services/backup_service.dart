import 'dart:convert';
import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/category.dart';
import '../models/task.dart';

/// 🎯 Serviço responsável por exportação, importação e truncamento de dados (Backup).
class BackupService {
  final Isar db;

  /// 🚀 Construtor recebe a instância do banco já aberta
  BackupService(this.db);

  // ─────────────────────────────────────────────────────────────────────────────
  // 🔥 BACKUP COMPLETO E RESTORE
  // ─────────────────────────────────────────────────────────────────────────────

  /// 💾 Faz o backup completo em JSON (string)
  Future<String> exportFullBackup() async {
    final tasks = await db.tasks.where().findAll();
    final categories = await db.categorys.where().findAll();

    final data = {
      'tasks': tasks.map((e) => _taskToMap(e)).toList(),
      'categories': categories.map((e) => _categoryToMap(e)).toList(),
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

    await db.writeTxn(() async {
      await db.tasks.putAll(taskList);
      await db.categorys.putAll(categoryList);
    });
  }

  /// 🗑️ Apaga tudo do banco (truncate)
  Future<void> truncateAll() async {
    await db.writeTxn(() async {
      await db.tasks.clear();
      await db.categorys.clear();
    });
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
    final tasks = await db.tasks.filter().categoryIdEqualTo(categoryId).findAll();
    final categories = await db.categorys.filter().idEqualTo(categoryId).findAll();

    final data = {
      'tasks': tasks.map(_taskToMap).toList(),
      'categories': categories.map(_categoryToMap).toList(),
    };

    final json = const JsonEncoder.withIndent('  ').convert(data);

    return _saveBackupFile(json, 'backup_categoria_$categoryId');
  }

  /// ✔️ Exporta dados por status (concluído ou não)
  Future<File> exportDataByStatus(bool isCompleted) async {
    final tasks = await db.tasks.filter().isCompletedEqualTo(isCompleted).findAll();

    final categoryIds = tasks.map((t) => t.categoryId).whereType<int>().toSet().toList();

    final categories = await db.categorys
        .filter()
        .anyOf(categoryIds, (q, id) => q.idEqualTo(id))
        .findAll();

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
    final tasks = await db.tasks.filter().createdAtBetween(start, end).findAll();

    final categoryIds = tasks.map((t) => t.categoryId).whereType<int>().toSet().toList();

    final categories = await db.categorys
        .filter()
        .anyOf(categoryIds, (q, id) => q.idEqualTo(id))
        .findAll();

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
    'dueDate': task.dueDate?.toIso8601String(),
    'isCompleted': task.isCompleted,
    'priority': task.priority,
    'categoryId': task.categoryId,
    'createdAt': task.createdAt.toIso8601String(),
  };

  Task _mapToTask(Map<String, dynamic> map) => Task(
    id: map['id'],
    title: map['title'],
    description: map['description'],
    dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
    isCompleted: map['isCompleted'],
    priority: map['priority'],
    categoryId: map['categoryId'],
    createdAt: DateTime.parse(map['createdAt']),
  );

  Map<String, dynamic> _categoryToMap(Category category) => {
    'id': category.id,
    'name': category.name,
    'color': category.color,
    'createdAt': category.createdAt.toIso8601String(),
  };

  Category _mapToCategory(Map<String, dynamic> map) => Category(
    id: map['id'],
    name: map['name'],
    color: map['color'],
    createdAt: DateTime.parse(map['createdAt']),
  );

  // ─────────────────────────────────────────────────────────────────────────────
  // 💾 SALVAMENTO DE ARQUIVO
  // ─────────────────────────────────────────────────────────────────────────────

  Future<File> _saveBackupFile(String json, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();

    final timestamp = _timestamp();
    final file = File('${dir.path}/$fileName\_$timestamp.json');

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
