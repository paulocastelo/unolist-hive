import 'package:isar/isar.dart';
import '../models/task.dart';

/// 🎯 Serviço responsável por gerenciar operações no banco relacionadas às tarefas (Task).
class TaskService {
  // 🔗 Instância do banco Isar
  final Isar db;

  /// 🚀 Construtor que recebe a instância do banco já aberta
  TaskService(this.db);

  /// 🔥 Adiciona uma nova tarefa, com validação
  Future<void> addTask(Task task) async {
    _validateTask(task);

    await db.writeTxn(() async {
      await db.tasks.put(task);
    });
  }

  /// 🔄 Atualiza uma tarefa existente, com validação
  Future<void> updateTask(Task task) async {
    _validateTask(task);

    await db.writeTxn(() async {
      await db.tasks.put(task);
    });
  }

  /// 🔍 Valida os dados da tarefa antes de salvar ou atualizar
  void _validateTask(Task task) {
    // 🔍 Validação de título
    if (task.title.trim().isEmpty) {
      throw Exception('O título da tarefa não pode ser vazio.');
    }

    // 🔍 Validação de prioridade
    const prioridadesValidas = ['Alta', 'Média', 'Baixa'];
    if (!prioridadesValidas.contains(task.priority)) {
      throw Exception(
          'Prioridade inválida. Use: Alta, Média ou Baixa.');
    }
  }

  /// 🔍 Buscar todas as tarefas, ordenadas pela data de criação (mais recente primeiro)
  Future<List<Task>> getAllTasks() async {
    return await db.tasks.where().sortByCreatedAtDesc().findAll();
  }

  /// 🔍 Buscar tarefas por status (concluído ou não)
  Future<List<Task>> getTasksByCompletion(bool isCompleted) async {
    return await db.tasks
        .filter()
        .isCompletedEqualTo(isCompleted)
        .sortByCreatedAtDesc()
        .findAll();
  }

  /// 🔍 Buscar uma tarefa específica pelo ID
  Future<Task?> getTaskById(int id) async {
    return await db.tasks.get(id);
  }

  /// 🔍 Buscar tarefas vinculadas a uma categoria específica
  Future<List<Task>> getTasksByCategory(int categoryId) async {
    return await db.tasks
        .filter()
        .categoryIdEqualTo(categoryId)
        .sortByCreatedAtDesc()
        .findAll();
  }

  /// ❌ Deletar uma tarefa pelo ID
  Future<void> deleteTask(int id) async {
    await db.writeTxn(() async {
      await db.tasks.delete(id);
    });
  }
}
