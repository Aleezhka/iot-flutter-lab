import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop_app/domain/providers/mqtt_provider.dart';
import 'package:workshop_app/widgets/status_badge.dart';

class MachineCard extends StatelessWidget {
  const MachineCard({
    required this.id,
    required this.title,
    required this.status,
    required this.onEdit,
    required this.onDelete,
    super.key,
    this.isEmergency = false,
  });

  final String id;
  final String title;
  final String status;
  final bool isEmergency;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final tempStr = context.watch<MqttProvider>().temperatures[id] ?? '--';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isEmergency
            ? Colors.orange.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isEmergency ? Colors.orange : Colors.white10,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: $id',
                        style:
                            const TextStyle(fontSize: 11, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.thermostat, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '$tempStr °C',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                StatusBadge(status: status, isEmergency: isEmergency),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
