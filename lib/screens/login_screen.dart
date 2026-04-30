import 'package:flutter/material.dart';
import 'package:workshop_app/data/repositories/storage_interface.dart';
import 'package:workshop_app/widgets/custom_text_field.dart';
import 'package:workshop_app/widgets/workshop_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({required this.storage, super.key});
  final IStorageRepository storage;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String? _error;

  Future<void> _handleLogin() async {
    final email = _emailCtrl.text.trim();
    final user = await widget.storage.getUser(email);

    if (user != null && user['password'] == _passCtrl.text) {
      await widget.storage.setLoggedInUserId(email);
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() => _error = 'Невірний логін або пароль');
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.precision_manufacturing,
                size: 80, color: Color(0xFFFFB347),),
            const SizedBox(height: 48),
            if (_error != null) ...[
              Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
            ],
            CustomTextField(
                controller: _emailCtrl, hintText: 'Електронна пошта',),
            const SizedBox(height: 16),
            CustomTextField(
                controller: _passCtrl, hintText: 'Пароль', obscureText: true,),
            const SizedBox(height: 32),
            WorkshopButton(label: 'Увійти', onPressed: _handleLogin),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text('Новий робітник? Зареєструватися'),
            ),
          ],
        ),
      ),
    );
  }
}
