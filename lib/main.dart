import 'package:flutter/material.dart';
import 'package:workshop_app/screens/home_screen.dart';
import 'package:workshop_app/screens/login_screen.dart';
import 'package:workshop_app/screens/profile_screen.dart';
import 'package:workshop_app/screens/register_screen.dart';

void main() {
  runApp(const WorkshopApp());
}

class WorkshopApp extends StatelessWidget {
  const WorkshopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Workshop Sentinel',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFFFFB347),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
