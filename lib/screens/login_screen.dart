import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:workshop_app/data/repositories/storage_interface.dart';
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
      setState(() => _error = 'Немає з\'єднання з Інтернетом');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final email = _emailCtrl.text.trim();
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: _passCtrl.text,
      );
      await widget.storage.setLoggedInUserId(email);
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (_) {
      setState(() => _error = 'Невірний логін або пароль');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final isOnline = context.read<ConnectivityProvider>().isOnline;
    if (!isOnline) {
      setState(() => _error = 'Немає Інтернету для входу через Google');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final email = userCredential.user?.email ?? googleUser.email;

      await widget.storage.saveUser({
        'name': googleUser.displayName ?? 'Google User',
        'email': email,
      });
      await widget.storage.setLoggedInUserId(email);

      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      setState(() => _error = 'Помилка входу через Google: $e');
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
          child: CircularProgressIndicator(
            color: Color(0xFFFFB347),
          ),
        ),
      );
    }

    return Scaffold(
      body: Center(
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
              if (_error != null) ...[
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
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
                  onPressed: _handleGoogleSignIn,
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
      ),
    );
  }
}
