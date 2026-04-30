import 'package:flutter/material.dart';
import 'package:workshop_app/widgets/status_badge.dart';

class MachineCard extends StatelessWidget {
  const MachineCard({
    required this.title,
    required this.status,
    required this.onEdit,
    required this.onDelete,
    super.key,
    this.isEmergency = false,
  });

  final String title;
  final String status;
  final bool isEmergency;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        // Легкий помаранчевий фон для аварії, звичайний для інших
        color: isEmergency
            ? Colors.orange.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          // Помаранчева рамка для аварії
          color: isEmergency ? Colors.orange : Colors.white10,
          // Товстіша рамка, щоб привернути увагу
          width: isEmergency ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: onEdit,
                      child: const Icon(Icons.edit, size: 18),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onDelete,
                      child: const Icon(Icons.delete, size: 18),
                    ),
                  ],
                ),
              ],
            ),
            StatusBadge(
              status: status,
              isEmergency: isEmergency,
            ),
          ],
        ),
      ),
    );
  }
}
