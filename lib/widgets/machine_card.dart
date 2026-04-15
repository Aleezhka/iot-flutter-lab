import 'package:flutter/material.dart';
import 'package:workshop_app/widgets/status_badge.dart';

class MachineCard extends StatelessWidget {
  const MachineCard({
    required this.title,
    required this.status,
    super.key,
    this.isEmergency = false,
  });

  final String title;
  final String status;
  final bool isEmergency;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(
          color: isEmergency ? Colors.red : Colors.white10,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          StatusBadge(
            status: status,
            isEmergency: isEmergency,
          ),
        ],
      ),
    );
  }
}
