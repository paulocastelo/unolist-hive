
import '../../services/isar_service.dart';
import '../../services/backup_service.dart';

/// 🧪 Teste de Backup e Restore (Exportação e Importação)
Future<void> backupTest() async {
  print('💾 Iniciando testes de Backup e Restore');

  // 🔥 Inicializa o banco
  final isar = await IsarService().db;

  // 🔗 Inicializa o serviço de backup
  final backupService = BackupService(isar);

  // 💾 Exporta os dados
  final file = await backupService.exportAllData();
  print('💾 Backup salvo em: ${file.path}');

  // 🔄 Importa o backup
  await backupService.importData(file);
  print('🔄 Backup restaurado com sucesso.');

  print('✅ Teste de Backup e Restore concluído.\n');
}
