import 'package:flutter/material.dart';

// 📝 Importa as páginas principais
import 'ui/pages/home_page.dart';
import 'ui/pages/category_page.dart';
import 'ui/pages/backup_page.dart';
import 'ui/pages/settings_page.dart';
import 'ui/pages/about_page.dart'; //<-- Página About

void main() {
  runApp(const UnoListApp());
}

class UnoListApp extends StatelessWidget {
  const UnoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UnoList',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      home: const HomePage(), // 🏠 Página inicial
      routes: {
        '/categories': (_) => const CategoryPage(),
        '/backup': (_) => const BackupPage(),
        '/settings': (_) => const SettingsPage(),
        '/about': (_) => const AboutPage(),
      },
    );
  }
}
