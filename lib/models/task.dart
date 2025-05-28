import 'package:isar/isar.dart';

part 'task.g.dart';

@collection
class Task {
  Id id = Isar.autoIncrement;

  late String title;
  String? description;
  DateTime? dueDate;
  int? categoryId;
  bool isCompleted = false;
  late String priority;
  late DateTime createdAt;

  /// 🚀 Construtor principal
  Task({
    this.id = Isar.autoIncrement,
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
      id: json['id'] ?? Isar.autoIncrement,
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
