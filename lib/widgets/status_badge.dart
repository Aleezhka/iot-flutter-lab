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
    final color = isEmergency ? Colors.red : Colors.green;

    return Row(
      children: [
        CircleAvatar(
          radius: 4,
          backgroundColor: color,
        ),
        const SizedBox(width: 6),
        Text(
          status,
          style: TextStyle(
            color: color,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
