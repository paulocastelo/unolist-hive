import 'package:isar/isar.dart';
import '../models/task.dart';

/// 🎯 Serviço responsável por gerenciar operações no banco relacionadas às tarefas (Task).
class TaskService {
  // 🔗 Instância do banco Isar
  final Isar db;

  /// 🚀 Construtor que recebe a instância do banco já aberta
  TaskService(this.db);

  // 🔸 Adicionar uma nova tarefa
  Future<void> addTask(Task task) async {
    await db.writeTxn(() async {
      await db.tasks.put(task);
    });
  }

  // 🔍 Buscar todas as tarefas, ordenadas pela data de criação (mais recente primeiro)
  Future<List<Task>> getAllTasks() async {
    return await db.tasks
        .where()
        .sortByCreatedAtDesc()
        .findAll();
  }

  // 🔍 Buscar tarefas por status (concluído ou não)
  Future<List<Task>> getTasksByCompletion(bool isCompleted) async {
    return await db.tasks
        .filter()
        .isCompletedEqualTo(isCompleted)
        .sortByCreatedAtDesc()
        .findAll();
  }

  // 🔍 Buscar uma tarefa específica pelo ID
  Future<Task?> getTaskById(int id) async {
    return await db.tasks.get(id);
  }

  // 🔍 Buscar tarefas vinculadas a uma categoria específica
  Future<List<Task>> getTasksByCategory(int categoryId) async {
    return await db.tasks
        .filter()
        .categoryIdEqualTo(categoryId)
        .sortByCreatedAtDesc()
        .findAll();
  }

  // 🔄 Atualizar uma tarefa existente (se ela já existir no banco)
  Future<void> updateTask(Task task) async {
    await db.writeTxn(() async {
      await db.tasks.put(task);
    });
  }

  // ❌ Deletar uma tarefa pelo ID
  Future<void> deleteTask(int id) async {
    await db.writeTxn(() async {
      await db.tasks.delete(id);
    });
  }
}
