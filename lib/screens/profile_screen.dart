import 'package:flutter/material.dart';
import 'package:workshop_app/widgets/workshop_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PROFILE')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
            ),
            const SizedBox(height: 32),
            const ListTile(
              title: Text('Worker'),
              subtitle: Text('Oleh Protsiuk'),
            ),
            const ListTile(
              title: Text('Access'),
              subtitle: Text('Level 3 (Senior)'),
            ),
            const Spacer(),
            WorkshopButton(
              label: 'Logout',
              color: Colors.redAccent,
              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
          ],
        ),
      ),
    );
  }
}
