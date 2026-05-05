import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workshop_app/data/repositories/storage_interface.dart';
import 'package:workshop_app/domain/cubits/auth_cubit.dart';
import 'package:workshop_app/domain/validators.dart';
import 'package:workshop_app/widgets/custom_text_field.dart';
import 'package:workshop_app/widgets/workshop_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({required this.storage, super.key});
  final IStorageRepository storage;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  void _onRegisterPressed() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<AuthCubit>().register(
          _nameCtrl.text.trim(),
          _emailCtrl.text.trim(),
          _passCtrl.text,
        );
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
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Успішно! Тепер увійдіть.')),
            );
            Navigator.pop(context);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
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
                  if (state is AuthLoading)
                    const CircularProgressIndicator(color: Color(0xFFFFB347))
                  else
                    WorkshopButton(
                      label: 'Створити акаунт',
                      onPressed: _onRegisterPressed,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
