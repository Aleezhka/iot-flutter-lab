import 'package:flutter/material.dart';
import 'package:workshop_app/widgets/machine_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cols = width > 600 ? 3 : 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('WORKSHOP HUB'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: cols,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: const [
          MachineCard(title: 'Lathe #1', status: 'Active'),
          MachineCard(
            title: 'CNC Router',
            status: 'Error',
            isEmergency: true,
          ),
          MachineCard(title: 'Drill Press', status: 'Active'),
          MachineCard(title: 'Extractor', status: 'Active'),
        ],
      ),
    );
  }
}
