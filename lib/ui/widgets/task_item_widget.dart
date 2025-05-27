import 'package:flutter/material.dart';

/// Widget responsável por exibir um item da lista de tarefas.
class TaskItemWidget extends StatelessWidget {
  final String title;
  final String category;
  final String date;
  final bool isCompleted;

  final VoidCallback onToggleComplete;
  final VoidCallback onTap;

  const TaskItemWidget({
    Key? key,
    required this.title,
    required this.category,
    required this.date,
    required this.isCompleted,
    required this.onToggleComplete,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Ação ao tocar no card
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Checkbox ou indicador de status
            GestureDetector(
              onTap: onToggleComplete,
              child: Icon(
                isCompleted
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: isCompleted ? Colors.green : Colors.grey,
              ),
            ),

            const SizedBox(width: 12),

            // 📄 Informações da tarefa
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔥 Título
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 🏷️ Categoria e 📅 Data
                  Row(
                    children: [
                      const Icon(Icons.folder_open, size: 16),
                      const SizedBox(width: 4),
                      Text(category),

                      const SizedBox(width: 16),

                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 4),
                      Text(date),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
