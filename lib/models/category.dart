import 'package:isar/isar.dart';

part 'category.g.dart';

@collection
class Category {
  Id id = Isar.autoIncrement;

  late String name;
  late int color;
  late DateTime createdAt;

  /// 🚀 Construtor principal
  Category({
    this.id = Isar.autoIncrement,
    required this.name,
    required this.color,
    required this.createdAt,
  });

  /// 🏗️ Fábrica simplificada
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

  /// 🔄 Serialização → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// 🔄 Desserialização ← JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? Isar.autoIncrement,
      name: json['name'],
      color: json['color'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
