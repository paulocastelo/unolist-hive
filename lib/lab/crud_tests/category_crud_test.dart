import 'package:hive/hive.dart';

import '../../models/category.dart';
import '../../models/task.dart';
import '../../services/category_service.dart';

/// 🔥 Função de teste para operações CRUD da entidade Category.
Future<void> categoryCrudTest() async {
  print('🧪 Iniciando testes de Category CRUD');

  // 🔥 Inicializa as boxes
  final categoryBox = Hive.box<Category>('categories');
  final taskBox = Hive.box<Task>('tasks');

  // 🔗 Inicializa o serviço de categorias com as boxes
  final categoryService = CategoryService(categoryBox: categoryBox, taskBox: taskBox);

  // 💾 Adiciona as categorias no banco
  await categoryService.addCategory('Trabalho', 0xFFFF5722);
  await categoryService.addCategory('Estudos', 0xFF3F51B5);

  // 🔍 Busca e imprime todas as categorias
  final categories = await categoryService.getAllCategories();
  print('📂 Categorias encontradas no banco:');
  for (var c in categories) {
    print('→ ${c.id}: ${c.name}');
  }

  // ❌ Deleta a categoria 'Trabalho'
  final work = categories.firstWhere((c) => c.name == 'Trabalho');
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
