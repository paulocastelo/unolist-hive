import 'package:isar/isar.dart';
import '../../services/isar_service.dart';
import '../../models/category.dart';
import '../../services/category_service.dart';

/// 🔥 Função de teste para operações CRUD da entidade Category.
Future<void> categoryCrudTest() async {
  print('🧪 Iniciando testes de Category CRUD');

  // 🔥 Obtém a instância do banco
  final isar = await IsarService().db;

  // 🔗 Inicializa o serviço de categorias com o banco Isar
  final categoryService = CategoryService(isar);

  // 🏗️ Cria duas categorias para teste
  final work = Category.create(name: 'Trabalho', color: 0xFFFF5722);
  final study = Category.create(name: 'Estudos', color: 0xFF3F51B5);

  // 💾 Adiciona as categorias no banco
  await categoryService.addCategory(work);
  await categoryService.addCategory(study);

  // 🔍 Busca e imprime todas as categorias
  final categories = await categoryService.getAllCategories();
  print('📂 Categorias encontradas no banco:');
  for (var c in categories) {
    print('→ ${c.id}: ${c.name}');
  }

  // ❌ Deleta a categoria 'Trabalho'
  await categoryService.deleteCategory(work.id);
  print('🗑️ Categoria "Trabalho" deletada.');

  // 🔍 Busca novamente para verificar
  final updatedCategories = await categoryService.getAllCategories();
  print('📂 Categorias restantes após deleção:');
  for (var c in updatedCategories) {
    print('→ ${c.id}: ${c.name}');
  }

  print('✅ Teste Category CRUD concluído.\n');
}
