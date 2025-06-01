import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import '../../models/task.dart';
import '../../models/category.dart';
import '../../services/backup_service.dart';
import '../widgets/custom_dialogs.dart'; // 👈 Import novo!

/// ⚙️ Página de configurações do UnoList.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final BackupService _backupService;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  void _initializeServices() {
    final taskBox = Hive.box<Task>('tasks');
    final categoryBox = Hive.box<Category>('categories');
    _backupService = BackupService(taskBox: taskBox, categoryBox: categoryBox);
  }

  Future<void> _handleBackup() async {
    try {
      final json = await _backupService.exportFullBackup();
      final dir = await getApplicationDocumentsDirectory();
      final file = File(
        '${dir.path}/backup_${DateTime.now().millisecondsSinceEpoch}.json',
      );
      await file.writeAsString(json);
      _showSnack('✅ Backup saved: ${file.path}');
    } catch (e) {
      _showSnack('❌ Backup failed: $e');
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
        final json = await file.readAsString();

        await _backupService.importFullBackup(json);
        _showSnack('✅ Restore completed successfully');
      }
    } catch (e) {
      _showSnack('❌ Restore failed: $e');
    }
  }

  Future<void> _handleReset() async {
    final confirm = await CustomDialogs.showConfirmationDialog(
      context,
      title: 'Reset App',
      content: 'Are you sure you want to delete ALL data?\nThis cannot be undone.',
      confirmText: 'Reset',
      cancelText: 'Cancel',
    );

    if (confirm == true) {
      await _backupService.truncateAll();
      _showSnack('🗑️ All data has been deleted');
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Backup'),
            subtitle: const Text('Export data to JSON'),
            onTap: _handleBackup,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.upload),
            title: const Text('Restore'),
            subtitle: const Text('Import data from JSON'),
            onTap: _handleRestore,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text('Reset App'),
            subtitle: const Text('Delete all data'),
            onTap: _handleReset,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            subtitle: const Text('App information'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'UnoList',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2025 ZeroAvenger Studios',
              );
            },
          ),
        ],
      ),
    );
  }
}
