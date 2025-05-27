import 'package:isar/isar.dart';

part 'task.g.dart';

@Collection()
class Task {
  // 🔑 ID único da tarefa
  Id id = Isar.autoIncrement;

  // 🏷️ Título da tarefa
  late String title;

  // 📝 Descrição opcional
  String? description;

  // 📅 Data de vencimento opcional
  DateTime? dueDate;

  // ✅ Status da tarefa (concluída ou não)
  late bool isCompleted;

  // 🎯 Prioridade da tarefa (Alta, Média, Baixa)
  late String priority;

  // 🔗 Categoria relacionada (opcional)
  int? categoryId;

  // 📅 Data de criação (obrigatória)
  late DateTime createdAt;

  // 🚀 Construtor principal (regras do Isar)
  Task({
    this.id = Isar.autoIncrement,
    required this.title,
    this.description,
    this.dueDate,
    required this.isCompleted,
    required this.priority,
    this.categoryId,
    required this.createdAt,
  });

  // 🛠️ Factory para facilitar a criação
  factory Task.create({
    required String title,
    String? description,
    DateTime? dueDate,
    String priority = 'Média',
    int? categoryId,
  }) {
    return Task(
      title: title,
      description: description,
      dueDate: dueDate,
      isCompleted: false,
      priority: priority,
      categoryId: categoryId,
      createdAt: DateTime.now(),
    );
  }
}
