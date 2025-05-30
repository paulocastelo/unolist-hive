import '../../services/isar_service.dart';
import '../../services/task_service.dart';

/// 🔍 Função de teste para consultas (queries) na entidade Task.
Future<void> taskQueryTest() async {
  print('🔍 Iniciando testes de Queries de Tasks');

  // 🔥 Obtém a instância do banco
  final isar = await IsarService().db;

  // 🔗 Inicializa o serviço de tarefas com o banco Isar
  final taskService = TaskService(isar);

  // 🔍 Busca tarefas concluídas
  final completedTasks = await taskService.getTasksByCompletion(true);
  print('✔️ Tarefas concluídas:');
  for (var t in completedTasks) {
    print('→ ${t.id}: ${t.title}');
  }

  // 🔍 Busca tarefas pendentes
  final pendingTasks = await taskService.getTasksByCompletion(false);
  print('❌ Tarefas pendentes:');
  for (var t in pendingTasks) {
    print('→ ${t.id}: ${t.title}');
  }

  print('✅ Teste de Query concluído.\n');
}
