import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workshop_app/data/repositories/storage_interface.dart';
import 'package:workshop_app/domain/cubits/auth_cubit.dart';
import 'package:workshop_app/domain/providers/connectivity_provider.dart';
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
  bool _isCheckingAutoLogin = true;

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
      setState(() => _isCheckingAutoLogin = false);
    }
  }

  void _onLoginPressed() {
    final isOnline = context.read<ConnectivityProvider>().isOnline;
    if (!isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Немає інтернету'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    context.read<AuthCubit>().login(_emailCtrl.text.trim(), _passCtrl.text);
  }

  void _onGooglePressed() {
    final isOnline = context.read<ConnectivityProvider>().isOnline;
    if (!isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Немає інтернету'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    context.read<AuthCubit>().loginWithGoogle();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingAutoLogin) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFFB347)),
        ),
      );
    }

    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacementNamed(context, '/home');
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
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFB347)),
            );
          }

          return Center(
            child: SingleChildScrollView(
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
                  WorkshopButton(label: 'Увійти', onPressed: _onLoginPressed),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: const RoundedRectangleBorder(),
                      ),
                      icon: const Icon(Icons.g_mobiledata, size: 32),
                      label: const Text(
                        'УВІЙТИ ЧЕРЕЗ GOOGLE',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: _onGooglePressed,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    child: const Text('Новий робітник? Зареєструватися'),
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
