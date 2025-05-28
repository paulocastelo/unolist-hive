import 'package:isar/isar.dart';
import '../models/category.dart';
import '../models/task.dart';

/// 🎯 Serviço responsável por gerenciar operações no banco relacionadas às categorias (Category).
class CategoryService {
  // 🔗 Instância do banco Isar
  final Isar db;

  /// 🚀 Construtor que recebe a instância do banco já aberta
  CategoryService(this.db);

  /// 🔥 Adiciona uma nova categoria, com validação
  Future<void> addCategory(Category category) async {
    // 🔍 Validação: Nome não pode ser vazio
    if (category.name.trim().isEmpty) {
      throw Exception('O nome da categoria não pode ser vazio.');
    }

    await db.writeTxn(() async {
      await db.categorys.put(category); // ✅ put = insere ou atualiza
    });
  }

  /// 🔄 Atualiza uma categoria existente, com validação
  Future<void> updateCategory(Category category) async {
    if (category.name.trim().isEmpty) {
      throw Exception('O nome da categoria não pode ser vazio.');
    }

    await db.writeTxn(() async {
      await db.categorys.put(category);
    });
  }

  /// 🔍 Buscar todas as categorias ordenadas por nome
  Future<List<Category>> getAllCategories() async {
    return await db.categorys
        .where()
        .sortByName()
        .findAll();
  }

  /// 🔍 Buscar uma categoria específica pelo ID
  Future<Category?> getCategoryById(int id) async {
    return await db.categorys.get(id);
  }

  /// 🗑️ Deleta uma categoria, movendo tarefas para 'Sem Categoria' se necessário
  Future<void> deleteCategory(int id) async {
    // 📦 Recupera a categoria pelo ID
    final category = await db.categorys.get(id);
    if (category == null) {
      throw Exception('Categoria não encontrada.');
    }

    // 🔒 Impede deletar a própria 'Sem Categoria'
    final uncategorized = await getOrCreateUncategorized();
    if (category.id == uncategorized.id) {
      throw Exception('A categoria "Sem Categoria" não pode ser deletada.');
    }

    // 🔍 Verifica tarefas vinculadas
    final tasksWithCategory = await db.tasks
        .filter()
        .categoryIdEqualTo(id)
        .findAll();

    if (tasksWithCategory.isNotEmpty) {
      // 🔄 Move tarefas para 'Sem Categoria'
      await db.writeTxn(() async {
        for (var task in tasksWithCategory) {
          task.categoryId = uncategorized.id;
          await db.tasks.put(task);
        }
      });
    }

    // 🗑️ Deleta a categoria
    await db.writeTxn(() async {
      await db.categorys.delete(id);
    });
  }



  /// 🔧 Retorna a categoria 'Sem Categoria', criando se não existir
  Future<Category> getOrCreateUncategorized() async {
    // 🔍 Verifica se já existe
    final existing = await db.categorys
        .filter()
        .nameEqualTo('Sem Categoria')
        .findFirst();

    if (existing != null) {
      return existing;
    }

    // ➕ Cria se não existir
    final newCategory = Category.create(
      name: 'Sem Categoria',
      color: 0xFF9E9E9E, // Cinza padrão
    );

    await db.writeTxn(() async {
      await db.categorys.put(newCategory);
    });

    return newCategory;
  }
}
