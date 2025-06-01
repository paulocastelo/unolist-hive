import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../models/category.dart';
import '../../models/task.dart';
import '../../services/backup_service.dart';
import '../widgets/custom_dialogs.dart'; // 👈 Import novo!'

/// Página de Backup e Restore de dados.
class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

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

  void _initializeService() {
    final taskBox = Hive.box<Task>('tasks');
    final categoryBox = Hive.box<Category>('categories');
    _backupService = BackupService(taskBox: taskBox, categoryBox: categoryBox);
  }

  Future<void> _handleBackup() async {
    try {
      final file = await _backupService.exportAllData();
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

  Future<void> _handleRestore() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        await _backupService.importData(file);

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

  Future<void> _handleTruncate() async {
    final confirm = await CustomDialogs.showConfirmationDialog(
      context,
      title: 'Delete All Data',
      content: 'Are you sure you want to delete ALL data? This cannot be undone.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
    );

    if (confirm == true) {
      await _backupService.truncateAll();
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
