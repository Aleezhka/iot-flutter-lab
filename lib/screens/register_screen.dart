import 'package:flutter/material.dart';
import 'package:workshop_app/widgets/workshop_button.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('REGISTRATION')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const TextField(decoration: InputDecoration(hintText: 'Name')),
            const SizedBox(height: 16),
            const TextField(decoration: InputDecoration(hintText: 'Specialty')),
            const SizedBox(height: 16),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(hintText: 'Password'),
            ),
            const SizedBox(height: 32),
            WorkshopButton(
              label: 'Create Account',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
