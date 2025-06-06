import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  String id; // ⬅️ Troca de int para String

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  DateTime? dueDate;

  @HiveField(4)
  String? categoryId; // ⬅️ Também vamos precisar mudar esse campo porque categoryId era int.

  @HiveField(5)
  bool isCompleted;

  @HiveField(6)
  String priority;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  int level;

  /// 🚀 Construtor principal
  Task({
    required this.id, // Agora é String
    required this.title,
    this.description,
    this.dueDate,
    this.categoryId,
    this.isCompleted = false,
    required this.priority,
    required this.createdAt,
    this.level = 1,
  });

  /// 🏗️ Fábrica simplificada
  factory Task.create({
    required String id, // Passa o id como String
    required String title,
    String? description,
    DateTime? dueDate,
    String? categoryId, // Muda aqui também para String?
    String priority = 'Média',
    int level = 1,
  }) {
    return Task(
      id: id, // Recebe id já gerado
      title: title,
      description: description,
      dueDate: dueDate,
      categoryId: categoryId,
      isCompleted: false,
      priority: priority,
      level: level,
      createdAt: DateTime.now(),
    );
  }

  /// 🔄 Serialização → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'categoryId': categoryId,
      'isCompleted': isCompleted,
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
      'level': level,
    };
  }

  /// 🔄 Desserialização ← JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'], // String
      title: json['title'],
      description: json['description'],
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'])
          : null,
      categoryId: json['categoryId'], // Também String
      isCompleted: json['isCompleted'] ?? false,
      priority: json['priority'] ?? 'Média',
      createdAt: DateTime.parse(json['createdAt']),
      level: json['level'] ?? 1,
    );
  }
}
