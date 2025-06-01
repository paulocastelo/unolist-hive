import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/category.dart';
import '../models/task.dart';

/// 🎯 Serviço responsável por gerenciar operações no banco relacionadas às categorias (Category).
class CategoryService {
  final Box<Category> categoryBox;
  final Box<Task> taskBox;

  final _uuid = Uuid(); // 👈 Cria uma instância do UUID

  /// 🚀 Construtor que recebe as boxes abertas
  CategoryService({required this.categoryBox, required this.taskBox});

  /// 🔥 Adiciona uma nova categoria, gerando ID e validando
  Future<void> addCategory(String name, int color) async {
    if (name.trim().isEmpty) {
      throw Exception('O nome da categoria não pode ser vazio.');
    }

    final category = Category.create(
      id: _uuid.v4(), // 👈 Gera um UUID
      name: name,
      color: color,
    );

    await categoryBox.put(category.id, category);
  }

  /// 🔄 Atualiza uma categoria existente, com validação
  Future<void> updateCategory(Category category) async {
    if (category.name.trim().isEmpty) {
      throw Exception('O nome da categoria não pode ser vazio.');
    }

    await categoryBox.put(category.id, category);
  }

  /// 🔍 Buscar todas as categorias ordenadas por nome
  Future<List<Category>> getAllCategories() async {
    final categories = categoryBox.values.toList();
    categories.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return categories;
  }

  /// 🔍 Buscar uma categoria específica pelo ID
  Future<Category?> getCategoryById(String id) async {
    return categoryBox.get(id);
  }

  /// 🗑️ Deleta uma categoria, movendo tarefas para 'Sem Categoria' se necessário
  Future<void> deleteCategory(String id) async {
    final category = categoryBox.get(id);
    if (category == null) {
      throw Exception('Categoria não encontrada.');
    }

    final uncategorized = await getOrCreateUncategorized();

    if (category.id == uncategorized.id) {
      throw Exception('A categoria "Sem Categoria" não pode ser deletada.');
    }

    // Atualiza as tarefas que tinham essa categoria
    final tasksWithCategory = taskBox.values.where((task) => task.categoryId == id).toList();

    for (var task in tasksWithCategory) {
      task.categoryId = uncategorized.id;
      await task.save();
    }

    // Deleta a categoria
    await categoryBox.delete(id);
  }

  /// 🔧 Retorna a categoria 'Sem Categoria', criando se não existir
  Future<Category> getOrCreateUncategorized() async {
    try {
      final uncategorizedCategory = categoryBox.values.firstWhere(
            (category) => category.name == 'Sem Categoria',
      );
      return uncategorizedCategory;
    } catch (_) {
      // Se não existe, cria com UUID
      final newUncategorized = Category.create(
        id: _uuid.v4(),
        name: 'Sem Categoria',
        color: 0xFF9E9E9E,
      );
      await categoryBox.put(newUncategorized.id, newUncategorized);
      return newUncategorized;
    }
  }
}
