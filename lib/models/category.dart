import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'category.g.dart';

@HiveType(typeId: 0)
class Category extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int color;

  @HiveField(3)
  DateTime createdAt;

  /// 🚀 Construtor principal
  Category({
    required this.id,
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
      id: const Uuid().v4(),
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
      id: json['id'],
      name: json['name'],
      color: json['color'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  /// 🚧 Atributo temporário não salvo no Hive
  /// Serve apenas para controle interno (não serializa)
  // @HiveIgnore()
  bool isNew = false;
}
