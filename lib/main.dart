import 'package:flutter/material.dart';

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
        primarySwatch: Colors.blueGrey,
      ),
      home: const HomePage(),
    );
  }
}

/// 🔥 Tela inicial temporária para estruturação do projeto
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UnoList'),
      ),
      body: const Center(
        child: Text('🚀 Bem-vindo ao UnoList!'),
      ),
    );
  }
}
