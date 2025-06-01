import 'package:hive/hive.dart';

import '../../models/task.dart';
import '../../services/task_service.dart';

/// 🔥 Função de teste para operações CRUD da entidade Task.
Future<void> taskCrudTest() async {
  print('🧪 Iniciando testes de Task CRUD');

  // 🔥 Abre a box
  final taskBox = Hive.box<Task>('tasks');

  // 🔗 Inicializa o serviço de tarefas
  final taskService = TaskService(taskBox);

  // 💾 Adiciona a tarefa no banco
  await taskService.addTask(
    title: 'Fazer backup',
    description: 'Backup dos dados do UnoList',
    dueDate: DateTime.now(),
    priority: 'Alta',
  );

  // 🔍 Busca e imprime todas as tarefas
  final tasks = await taskService.getAllTasks();
  print('🗒️ Tarefas encontradas no banco:');
  for (var t in tasks) {
    print('→ ${t.id}: ${t.title}');
  }

  // ❌ Deleta a tarefa criada
  final task = tasks.firstWhere((t) => t.title == 'Fazer backup');
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
