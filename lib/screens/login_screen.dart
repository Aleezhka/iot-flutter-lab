import 'package:flutter/material.dart';
import 'package:workshop_app/widgets/workshop_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.precision_manufacturing,
              size: 80,
              color: Color(0xFFFFB347),
            ),
            const SizedBox(height: 48),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Worker ID',
                filled: true,
                fillColor: Colors.white10,
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                filled: true,
                fillColor: Colors.white10,
              ),
            ),
            const SizedBox(height: 32),
            WorkshopButton(
              label: 'Enter Workshop',
              onPressed: () => Navigator.pushNamed(context, '/home'),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text('New Worker? Register'),
            ),
          ],
        ),
      ),
    );
  }
}
