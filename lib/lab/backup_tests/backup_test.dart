import 'dart:io';

import '../../services/isar_service.dart';
import '../../services/backup_service.dart';

Future<void> backupTest() async {
  print('💾 Iniciando testes de Backup e Restore');

  final isarService = IsarService();
  final backupService = BackupService(isarService);

  final file = await backupService.exportData();
  print('💾 Backup salvo em: ${file.path}');

  await backupService.importData(file);
  print('🔄 Backup restaurado com sucesso.');

  print('✅ Teste de Backup e Restore concluído.\n');
}
