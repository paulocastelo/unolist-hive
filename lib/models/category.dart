import 'package:isar/isar.dart';

part 'category.g.dart';

@Collection()
class Category {
  // 🔑 ID gerado automaticamente pelo Isar
  Id id = Isar.autoIncrement;

  // 🏷️ Nome da categoria (ex.: Trabalho, Estudos)
  late String name;

  // 🎨 Cor da categoria em formato inteiro ARGB
  late int color;

  // 📅 Data de criação (obrigatória)
  late DateTime createdAt;

  // 🚀 Construtor principal (exigido pelo Isar)
  Category({
    this.id = Isar.autoIncrement,
    required this.name,
    required this.color,
    required this.createdAt,
  });

  // 🛠️ Factory para facilitar a criação
  factory Category.create({
    required String name,
    required int color,
  }) {
    return Category(
      name: name,
      color: color,
      createdAt: DateTime.now(),
    );
  }
}
