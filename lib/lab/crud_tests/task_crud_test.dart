import 'package:isar/isar.dart';
import '../../services/isar_service.dart';
import '../../models/task.dart';
import '../../services/task_service.dart';

/// 🔥 Função de teste para operações CRUD da entidade Task.
Future<void> taskCrudTest() async {
  print('🧪 Iniciando testes de Task CRUD');

  // 🔥 Obtém a instância do banco
  final isar = await IsarService().db;

  // 🔗 Inicializa o serviço de tarefas com o banco Isar
  final taskService = TaskService(isar);

  // 🏗️ Cria uma tarefa para teste
  final task = Task.create(
    title: 'Fazer backup',
    description: 'Backup dos dados do UnoList',
    dueDate: DateTime.now().add(const Duration(days: 1)),
    priority: 'Alta',
  );

  // 💾 Adiciona a tarefa no banco
  await taskService.addTask(task);

  // 🔍 Busca e imprime todas as tarefas
  final tasks = await taskService.getAllTasks();
  print('🗒️ Tarefas encontradas no banco:');
  for (var t in tasks) {
    print('→ ${t.id}: ${t.title}');
  }

  // ❌ Deleta a tarefa criada
  await taskService.deleteTask(task.id);
  print('🗑️ Tarefa deletada.');

  // 🔍 Busca novamente para validar a deleção
  final updatedTasks = await taskService.getAllTasks();
  print('🗒️ Tarefas restantes após deleção:');
  for (var t in updatedTasks) {
    print('→ ${t.id}: ${t.title}');
  }

  print('✅ Teste Task CRUD concluído.\n');
}
