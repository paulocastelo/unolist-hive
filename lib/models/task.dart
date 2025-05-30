import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  DateTime? dueDate;

  @HiveField(4)
  int? categoryId;

  @HiveField(5)
  bool isCompleted;

  @HiveField(6)
  String priority;

  @HiveField(7)
  DateTime createdAt;

  /// 🚀 Construtor principal
  Task({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    this.categoryId,
    this.isCompleted = false,
    required this.priority,
    required this.createdAt,
  });

  /// 🏗️ Fábrica simplificada
  factory Task.create({
    required String title,
    String? description,
    DateTime? dueDate,
    int? categoryId,
    String priority = 'Média',
  }) {
    return Task(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      description: description,
      dueDate: dueDate,
      categoryId: categoryId,
      isCompleted: false,
      priority: priority,
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
    };
  }

  /// 🔄 Desserialização ← JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      categoryId: json['categoryId'],
      isCompleted: json['isCompleted'] ?? false,
      priority: json['priority'] ?? 'Média',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
