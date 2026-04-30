import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    required this.status,
    required this.isEmergency,
    super.key,
  });

  final String status;
  final bool isEmergency;

  @override
  Widget build(BuildContext context) {
    // Активний - зелений, Неактивний - червоний
    final statusColor = status == 'Active' ? Colors.green : Colors.red;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 4,
          backgroundColor: statusColor,
        ),
        const SizedBox(width: 6),
        Text(
          status,
          style: TextStyle(
            color: statusColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        // Якщо аварія, додаємо помаранчеву іконку попередження
        if (isEmergency) ...[
          const SizedBox(width: 8),
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.orangeAccent,
            size: 16,
          ),
        ],
      ],
    );
  }
}
