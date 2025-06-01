import 'package:hive/hive.dart';

import '../../models/task.dart';
import '../../models/category.dart';
import '../../services/backup_service.dart';

/// 🧪 Teste de Backup e Restore (Exportação e Importação)
Future<void> backupTest() async {
  print('💾 Iniciando testes de Backup e Restore');

  // 🔥 Inicializa as boxes
  final taskBox = Hive.box<Task>('tasks');
  final categoryBox = Hive.box<Category>('categories');

  // 🔗 Inicializa o serviço de backup
  final backupService = BackupService(taskBox: taskBox, categoryBox: categoryBox);

  // 💾 Exporta os dados
  final file = await backupService.exportAllData();
  print('💾 Backup salvo em: ${file.path}');

  // 🔄 Importa o backup
  await backupService.importData(file);
  print('🔄 Backup restaurado com sucesso.');

  print('✅ Teste de Backup e Restore concluído.\n');
}
