import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../services/backup_service.dart';
import '../../services/isar_service.dart';

/// Página de Backup e Restore de dados.
class BackupPage extends StatefulWidget {
  const BackupPage({Key? key}) : super(key: key);

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  late final BackupService _backupService;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  /// 🔗 Inicializa o serviço de backup
  Future<void> _initializeService() async {
    final isar = await IsarService().db;
    _backupService = BackupService(isar);
  }

  /// 💾 Faz o backup completo
  Future<void> _handleBackup() async {
    try {
      final json = await _backupService.exportFullBackup(); // <-- The method 'exportFullBackup' isn't defined for the type 'BackupService'.
      final directory = await getApplicationDocumentsDirectory();

      final file = File('${directory.path}/backup_${DateTime.now().millisecondsSinceEpoch}.json');
      await file.writeAsString(json);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Backup saved at ${file.path}')),
      );
    } catch (e) {
      debugPrint('Backup error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Backup failed')),
      );
    }
  }

  /// 🔄 Faz o restore de um backup selecionado
  Future<void> _handleRestore() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final json = await file.readAsString();

        await _backupService.importFullBackup(json); // <-- The method 'importFullBackup' isn't defined for the type 'BackupService'.

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Restore completed successfully')),
        );
      }
    } catch (e) {
      debugPrint('Restore error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Restore failed')),
      );
    }
  }

  /// 🗑️ Apaga todos os dados (truncate)
  Future<void> _handleTruncate() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete All Data'),
        content: const Text('Are you sure you want to delete ALL data? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _backupService.truncateAll(); // <-- The method 'truncateAll' isn't defined for the type 'BackupService'.
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All data deleted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backup & Restore'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.backup),
                onPressed: _handleBackup,
                label: const Text('Backup'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.restore),
                onPressed: _handleRestore,
                label: const Text('Restore'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.delete_forever),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: _handleTruncate,
                label: const Text('Delete All Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
