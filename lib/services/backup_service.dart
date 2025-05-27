import 'dart:convert';
import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'isar_service.dart';
import '../models/category.dart';
import '../models/task.dart';

class BackupService {
  final IsarService _isarService;

  BackupService(this._isarService);

  // 📦 Exportar dados para arquivo JSON
  Future<File> exportData() async {
    final isar = await _isarService.db;

    // 🔍 Busca todos os dados
    final tasks = await isar.tasks.where().findAll();
    final categories = await isar.categorys.where().findAll();

    // 🔄 Converte para Map (serializável)
    final data = {
      'tasks': tasks.map((e) => _taskToMap(e)).toList(),
      'categories': categories.map((e) => _categoryToMap(e)).toList(),
    };

    // 🔤 Codifica para JSON
    final jsonString = jsonEncode(data);

    // 📂 Diretório do app
    final dir = await getApplicationDocumentsDirectory();

    // 📄 Cria o arquivo
    final file = File('${dir.path}/uno_list_backup.json');

    // 💾 Salva o JSON no arquivo
    return await file.writeAsString(jsonString);
  }

  // 🔄 Importar dados de um arquivo JSON
  Future<void> importData(File file) async {
    final isar = await _isarService.db;

    // 📖 Lê o conteúdo do arquivo
    final jsonString = await file.readAsString();

    // 🔤 Decodifica JSON para Map
    final data = jsonDecode(jsonString);

    // 🔥 Dentro de uma transação
    await isar.writeTxn(() async {
      // 🗑️ Limpa os dados atuais (opcional, mas comum)
      await isar.tasks.clear();
      await isar.categorys.clear();

      // 🔄 Restaura categorias
      final categories = (data['categories'] as List)
          .map((e) => _mapToCategory(e))
          .toList();
      await isar.categorys.putAll(categories);

      // 🔄 Restaura tarefas
      final tasks =
      (data['tasks'] as List).map((e) => _mapToTask(e)).toList();
      await isar.tasks.putAll(tasks);
    });
  }

  // 🔧 Helper — Serializa Task para Map
  Map<String, dynamic> _taskToMap(Task task) {
    return {
      'id': task.id,
      'title': task.title,
      'description': task.description,
      'dueDate': task.dueDate?.toIso8601String(),
      'isCompleted': task.isCompleted,
      'priority': task.priority,
      'categoryId': task.categoryId,
      'createdAt': task.createdAt.toIso8601String(),
    };
  }

  // 🔧 Helper — Deserializa Map para Task
  Task _mapToTask(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate:
      map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      isCompleted: map['isCompleted'],
      priority: map['priority'],
      categoryId: map['categoryId'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  // 🔧 Helper — Serializa Category para Map
  Map<String, dynamic> _categoryToMap(Category category) {
    return {
      'id': category.id,
      'name': category.name,
      'color': category.color,
      'createdAt': category.createdAt.toIso8601String(),
    };
  }

  // 🔧 Helper — Deserializa Map para Category
  Category _mapToCategory(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      color: map['color'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
