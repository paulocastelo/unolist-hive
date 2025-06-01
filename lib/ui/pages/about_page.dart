import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// ℹ️ Tela de informações sobre o app e links de apoio
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  // 🔗 Links de apoio
  static const String urlAbacashi = 'https://abacashi.com/p/seu-link';
  static const String urlKoFi = 'https://ko-fi.com/seu-link';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About UnoList'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            // 🏷️ Nome e versão
            const Text(
              'UnoList',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey),
            ),

            const Divider(height: 32),

            // 🔥 Descrição
            const Text(
              'UnoList é um aplicativo de lista de tarefas offline, '
                  'desenvolvido em Flutter, utilizando Hive Database para armazenamento local rápido e seguro.\n\n'
                  'Funcionalidades principais:\n'
                  '• Gerenciamento de tarefas e categorias.\n'
                  '• Backup e restauração local (JSON).\n'
                  '• Totalmente offline.\n'
                  '• Simples, leve e rápido.\n',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 24),

            // 💙 Agradecimento e apoio
            const Text(
              '💙 Se você gosta do que faço e quer apoiar este projeto, '
                  'pode contribuir com qualquer valor. Sua ajuda faz toda a diferença!',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () => abrirLink(urlAbacashi),
              icon: const Icon(Icons.favorite),
              label: const Text('Apoiar no Brasil (Abacashi)'),
            ),

            const SizedBox(height: 12),

            const Text(
              '🌎 If you’re outside Brazil and would like to support my work, '
                  'you can buy me a virtual coffee on Ko-fi! ☕ Thank you for your support!',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () => abrirLink(urlKoFi),
              icon: const Icon(Icons.coffee),
              label: const Text('Buy me a Coffee (International)'),
            ),

            const SizedBox(height: 24),

            const Divider(),

            // ℹ️ Créditos finais
            const Text(
              'Developed by Paulo Anderson Oliveira Castelo\n'
                  'aka ZeroAvenger\n'
                  '© 2025 ZeroAvenger Studios. All rights reserved.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// 🔗 Função para abrir links externos
  static void abrirLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Não foi possível abrir o link: $url';
    }
  }
}
