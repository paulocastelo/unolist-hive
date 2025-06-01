import 'package:flutter/material.dart';

/// 🎯 Drawer principal do UnoList
/// Usado para navegação entre telas do app.
class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // 🔵 Cabeçalho do Drawer
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'UnoList Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),

          // 📋 Lista de Navegação
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Tasks'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.folder),
            title: const Text('Categories'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/categories');
            },
          ),
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('Backup & Restore'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/backup');
            },
          ),

          const Divider(),

          // ℹ️ Sobre
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/about');
            },
          ),
        ],
      ),
    );
  }
}
