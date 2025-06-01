import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../models/task.dart';

/// 🔧 Serviço que gerencia as operações relacionadas a tarefas.
class TaskService {
  final Box<Task> _box;

  TaskService(this._box);

  /// 📚 Retorna todas as tarefas
  Future<List<Task>> getAllTasks() async {
    return _box.values.toList();
  }

  /// ➕ Adiciona uma nova tarefa
  Future<void> addTask({
    required String title,
    String? description,
    DateTime? dueDate,
    String? categoryId,
    String priority = 'Média',
  }) async {
    final newTask = Task(
      id: const Uuid().v4(), // Gera um UUID
      title: title,
      description: description,
      dueDate: dueDate,
      categoryId: categoryId,
      createdAt: DateTime.now(),
      isCompleted: false,
      priority: priority,
    );

    await _box.put(newTask.id, newTask);
  }

  /// 🔄 Atualiza uma tarefa existente
  Future<void> updateTask(Task task) async {
    await task.save();
  }

  /// 🗑️ Deleta uma tarefa
  Future<void> deleteTask(String id) async {
    await _box.delete(id);
  }

  /// 🧹 Deleta todas as tarefas
  Future<void> deleteAllTasks() async {
    await _box.clear();
  }

  /// 🔍 Retorna tarefas filtradas por status de conclusão
  Future<List<Task>> getTasksByCompletion(bool isCompleted) async {
    return _box.values.where((task) => task.isCompleted == isCompleted).toList();
  }
}
