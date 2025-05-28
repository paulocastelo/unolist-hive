import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/category.dart';
import '../models/task.dart';
import '../services/category_service.dart';


class IsarService {
  // 🔥 Instância singleton
  static final IsarService _instance = IsarService._internal();

  // 🔗 Getter para acessar a instância
  factory IsarService() {
    return _instance;
  }

  // 🏗️ Construtor interno privado
  IsarService._internal() {
    db = _initIsar();
  }

  // 📦 Instância do banco
  late Future<Isar> db;

  // 🚀 Inicializa o banco
  Future<Isar> _initIsar() async {
    final dir = await getApplicationDocumentsDirectory();

    final isar = await Isar.open(
      [
        TaskSchema,
        CategorySchema,
      ],
      directory: dir.path,
      inspector: true,
    );

    // 🚀 Garante que 'Sem Categoria' existe
    final categoryService = CategoryService(isar);
    await categoryService.getOrCreateUncategorized();

    return isar;
  }



  // 🔐 Fecha o banco (se necessário)
  Future<void> close() async {
    final isar = await db;
    await isar.close();
  }

  /// 🗑️ Exclui todos os registros do banco (truncate)
  /// Este método é exclusivo do ambiente de teste/desenvolvimento.
  Future<void> truncateAll() async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.tasks.clear();
      await isar.categorys.clear();
    });

    // 🚀 Após truncate, recria a categoria 'Sem Categoria'
    final categoryService = CategoryService(isar);
    await categoryService.getOrCreateUncategorized();

    print('🗑️ Banco zerado com sucesso.');
  }


}
