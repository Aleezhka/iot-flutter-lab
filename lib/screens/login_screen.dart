import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop_app/data/repositories/secure_storage_repository.dart';
import 'package:workshop_app/domain/providers/connectivity_provider.dart';
import 'package:workshop_app/widgets/custom_text_field.dart';
import 'package:workshop_app/widgets/workshop_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({required this.storage, super.key});
  final SecureStorageRepo storage;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String? _error;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    final email = await widget.storage.getLoggedInUserId();
    if (!mounted) return;

    if (email != null) {
      final isOnline = context.read<ConnectivityProvider>().isOnline;
      if (!isOnline) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Офлайн режим. Використовується локальна сесія.'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 5),
          ),
        );
      }
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogin() async {
    final isOnline = context.read<ConnectivityProvider>().isOnline;
    if (!isOnline) {
      setState(() => _error = 'Немає з\'єднання з Інтернетом для авторизації');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final email = _emailCtrl.text.trim();

      // 1. Авторизація через Firebase
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: _passCtrl.text,
      );

      // 2. Збереження сесії у захищене сховище для офлайн доступу
      await widget.storage.setLoggedInUserId(email);

      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (_) {
      setState(() => _error = 'Невірний логін або пароль');
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFFB347)),
        ),
      );
    }

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
            if (_error != null) ...[
              Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
            ],
            CustomTextField(
              controller: _emailCtrl,
              hintText: 'Електронна пошта',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _passCtrl,
              hintText: 'Пароль',
              obscureText: true,
            ),
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
