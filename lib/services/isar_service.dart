import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/category.dart';
import '../models/task.dart';

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

    return await Isar.open(
      [
        TaskSchema,
        CategorySchema,
      ],
      directory: dir.path,
      inspector: true,
    );
  }

  // 🔐 Fecha o banco (se necessário)
  Future<void> close() async {
    final isar = await db;
    await isar.close();
  }
}
