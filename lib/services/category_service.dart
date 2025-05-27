import 'package:isar/isar.dart';
import '../models/category.dart';

/// 🎯 Serviço responsável por gerenciar operações no banco relacionadas às categorias (Category).
class CategoryService {
  // 🔗 Instância do banco Isar
  final Isar db;

  /// 🚀 Construtor que recebe a instância do banco já aberta
  CategoryService(this.db);

  // 🔸 Adicionar uma nova categoria
  Future<void> addCategory(Category category) async {
    await db.writeTxn(() async {
      await db.categorys.put(category); // ✅ put = insere ou atualiza
    });
  }

  // 🔍 Buscar todas as categorias ordenadas por nome
  Future<List<Category>> getAllCategories() async {
    return await db.categorys
        .where()
        .sortByName()
        .findAll();
  }

  // 🔍 Buscar uma categoria específica pelo ID
  Future<Category?> getCategoryById(int id) async {
    return await db.categorys.get(id);
  }

  // 🔄 Atualizar uma categoria existente
  Future<void> updateCategory(Category category) async {
    await db.writeTxn(() async {
      await db.categorys.put(category);
    });
  }

  // ❌ Deletar uma categoria pelo ID
  Future<void> deleteCategory(int id) async {
    await db.writeTxn(() async {
      await db.categorys.delete(id);
    });
  }
}
