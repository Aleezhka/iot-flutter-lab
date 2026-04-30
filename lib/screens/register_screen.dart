import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workshop_app/data/repositories/secure_storage_repository.dart';
import 'package:workshop_app/domain/validators.dart';
import 'package:workshop_app/widgets/custom_text_field.dart';
import 'package:workshop_app/widgets/workshop_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({required this.storage, super.key});
  final SecureStorageRepo storage;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleRegister() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    try {
      // 1. Реєстрація у Firebase
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );

      // 2. Збереження додаткових даних (ім'я) локально
      await widget.storage.saveUser({
        'name': _nameCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Успішно! Тепер увійдіть.')),
        );
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'Помилка реєстрації'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('РЕЄСТРАЦІЯ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _nameCtrl,
                hintText: 'Ім\'я',
                validator: Validators.validateName,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _emailCtrl,
                hintText: 'Пошта',
                validator: Validators.validateEmail,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passCtrl,
                hintText: 'Пароль',
                obscureText: true,
                validator: Validators.validatePassword,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _confirmPassCtrl,
                hintText: 'Підтвердіть пароль',
                obscureText: true,
                validator: (val) =>
                    Validators.validateConfirmPassword(val, _passCtrl.text),
              ),
              const SizedBox(height: 32),
              if (_isLoading)
                const CircularProgressIndicator(color: Color(0xFFFFB347))
              else
                WorkshopButton(
                  label: 'Створити акаунт',
                  onPressed: _handleRegister,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
